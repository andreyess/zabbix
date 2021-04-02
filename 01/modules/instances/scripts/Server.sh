#!/bin/bash

sudo yum install -y openldap openldap-servers openldap-clients git
sudo systemctl start slapd
sudo systemctl enable slapd
sudo systemctl status slapd
sudo firewall-cmd --add-service ldap

git clone https://github.com/andreyess/ldap-config.git
cd ldap-config

export PASSWORD=$(slappasswd -h {SSHA} -s ldppassword)

sed -i "s:PASSWORD:${PASSWORD}:" ldaprootpasswd.ldif

sudo ldapadd -Y EXTERNAL -H ldapi:/// -f ldaprootpasswd.ldif

sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
sudo chown -R ldap:ldap /var/lib/ldap/DB_CONFIG
sudo systemctl restart slapd
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif


sed -i "s:PASSWORD:${PASSWORD}:" ldapdomain.ldif
sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ldapdomain.ldif
sudo ldapadd -x -D cn=Manager,dc=devopsldab,dc=com -w ldppassword -f baseldapdomain.ldif

sudo ldapadd -x -w ldppassword -D "cn=Manager,dc=devopsldab,dc=com" -f ldapgroup.ldif


sudo ldapadd -x -D cn=Manager,dc=devopsldab,dc=com -w ldppassword -f ldapuser.ldif
sudo ldappasswd -s password123 -w ldppassword -D "cn=Manager,dc=devopsldab,dc=com" -x "uid=akarpyza,ou=People,dc=devopsldab,dc=com"


# phpldapadmin installation
sudo yum install -y php-ldap php-mbstring php-pear php-xml epel-release
sudo yum -y install phpldapadmin

sed -i '397 s://::' /etc/phpldapadmin/config.php
sed -i '398d' /etc/phpldapadmin/config.php
sed -i '11 a    Require all granted' /etc/httpd/conf.d/phpldapadmin.conf

sudo systemctl restart httpd