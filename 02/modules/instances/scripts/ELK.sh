#!/bin/bash

# Repository connection
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

sudo echo '''[elasticsearch]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md''' > /etc/yum.repos.d/elasticsearch.repo

# Elasticsearch

sudo yum install -y elasticsearch 
#sudo vim /etc/elasticsearch/elasticsearch.yml network.host: "localhost" http.port:9200 cluster.initial_master_nodes: ["<PrivateIP"]
sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/' /etc/elasticsearch/elasticsearch.yml
sed -i 's/#http.port:/http.port:/' /etc/elasticsearch/elasticsearch.yml
echo 'discovery.seed_hosts: ["127.0.0.1", "[::1]"]/' >> /etc/elasticsearch/elasticsearch.yml
#sed -i 's/#discovery.seed_hosts: ["host1", "host2"]/discovery.seed_hosts: ["127.0.0.1", "[::1]"]/' /etc/elasticsearch/elasticsearch.yml

sudo systemctl start elasticsearch.service
sudo systemctl enable elasticsearch.service

# Kibana
sudo yum install -y kibana
sed -i 's/#elasticsearch.hosts:/elasticsearch.hosts:/' /etc/kibana/kibana.yml
sed -i 's/#server.port:/server.port:/' /etc/kibana/kibana.yml
sed -i 's/#server.host: "localhost"/server.host: 0.0.0.0/' /etc/kibana/kibana.yml

sudo systemctl start kibana.service
sudo systemctl enable kibana.service
