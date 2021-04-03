#!/bin/bash
#
# This script will install tomcat web-server to the 
# vm running on CentOS7


# Tomcat installation

yum install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 wget unzip
wget http://ftp.wayne.edu/apache/tomcat/tomcat-9/v9.0.44/bin/apache-tomcat-9.0.44.zip
unzip apache-tomcat-9.0.44.zip -d /opt

cd /opt
mv apache-tomcat-9.0.44/ tomcat
echo "export CATALINA_HOME='/opt/tomcat/'" >> ~/.bashrc
source ~/.bashrc
useradd -r tomcat --shell /bin/false

chown -R tomcat:tomcat /opt/tomcat/
chmod +x /opt/tomcat/bin/*.sh

echo '''
[Unit]
Description=Apache Tomcat 9
After=syslog.target network.target
[Service]
User=tomcat
Group=tomcat
Type=forking
#Environment=CATALINA_PID=/opt/tomcat/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
#Environment=CATALINA_BASE=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=on-failure
[Install]
WantedBy=multi-user.target
''' > /etc/systemd/system/tomcat.service

# clusterjsp page configuration
wget --no-check-certificate --content-disposition https://github.com/andreyess/clusterjsp.war/raw/main/clusterjsp.war
mv clusterjsp.war /opt/tomcat/webapps/

# Start tomcat service
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat



# Logstash configuration
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

sudo echo '''[logstash]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md''' > /etc/yum.repos.d/logstash.repo

sudo yum install -y logstash

sudo echo '''input {
    file {
        path => "/opt/tomcat/logs/catalina.out"
        start_position => "beginning"
    }
}

output {
    elasticsearch {
        hosts => ["ELK:9200"]
    }
    stdout { codec => rubydebug }
}
''' > /etc/logstash/conf.d/tomcat.conf

sudo systemctl start logstash.service
sudo systemctl enable logstash.service