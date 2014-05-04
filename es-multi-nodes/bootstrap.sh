#!/usr/bin/env bash

rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

apt-get update

apt-get install -y curl

apt-get install -y openjdk-7-jre-headless

apt-get install -y nginx

cp /vagrant/nginx.es.lb.conf /etc/nginx/nginx.conf
/etc/init.d/nginx restart

wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz
tar xvzf elasticsearch-1.1.1.tar.gz

elasticsearch-1.1.1/bin/plugin -install mobz/elasticsearch-head
elasticsearch-1.1.1/bin/plugin -install lukas-vlcek/bigdesk
elasticsearch-1.1.1/bin/plugin -install karmi/elasticsearch-paramedic

cp -r elasticsearch-1.1.1 es-node1 
cp -r elasticsearch-1.1.1 es-node2 
cp -r elasticsearch-1.1.1 es-node3
cp -r elasticsearch-1.1.1 es-node4
cp -r elasticsearch-1.1.1 es-node5

cp /vagrant/elasticsearch.node1.yml es-node1/config/elasticsearch.yml
cp /vagrant/elasticsearch.node2.yml es-node2/config/elasticsearch.yml
cp /vagrant/elasticsearch.node3.yml es-node3/config/elasticsearch.yml
cp /vagrant/elasticsearch.node4.yml es-node4/config/elasticsearch.yml
cp /vagrant/elasticsearch.node5.yml es-node5/config/elasticsearch.yml

echo "starting node 1"
es-node1/bin/elasticsearch -d
sleep 2

echo "starting node 2"
es-node2/bin/elasticsearch -d
sleep 2

echo "starting node 3"
es-node3/bin/elasticsearch -d
sleep 2

echo "starting node 4"
es-node4/bin/elasticsearch -d
sleep 2

echo "starting node 5"
es-node5/bin/elasticsearch -d


