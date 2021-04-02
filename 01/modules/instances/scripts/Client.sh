#!/bin/bash

sudo yum -y install openldap-clients nss-pam-ldapd authconfig
sudo authconfig --enableldap \
    --enableldapauth \
    --ldapserver=SERVER \
    --ldapbasedn="dc=devopsldab,dc=com" \
    --enablemkhomedir \
    --update

getent passwd

sudo systemctl restart  nslcd

sudo sed -i "s:PasswordAuthentication no:PasswordAuthentication yes:" /etc/ssh/sshd_config
sudo systemctl restart sshd