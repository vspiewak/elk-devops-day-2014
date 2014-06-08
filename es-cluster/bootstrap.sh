#!/usr/bin/env bash

echo "Set Europe/Paris as localtime"
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

echo "Update system"
apt-get -y -qq update

echo "Install curl"
apt-get install -y -qq curl

echo "Install jre 7"
apt-get install -y -qq openjdk-7-jre-headless

echo "Install nginx"
apt-get install -y -qq nginx

cp /vagrant/nginx.es.lb.conf /etc/nginx/nginx.conf
/etc/init.d/nginx restart

echo "Install Elasticsearch"
curl -s -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz
tar xzf elasticsearch-1.1.1.tar.gz

elasticsearch-1.1.1/bin/plugin -install mobz/elasticsearch-head
elasticsearch-1.1.1/bin/plugin -install lukas-vlcek/bigdesk
elasticsearch-1.1.1/bin/plugin -install karmi/elasticsearch-paramedic
elasticsearch-1.1.1/bin/plugin -install royrusso/elasticsearch-HQ
elasticsearch-1.1.1/bin/plugin -i elasticsearch/marvel/latest

cp -r elasticsearch-1.1.1 es-node1 
cp -r elasticsearch-1.1.1 es-node2 
cp -r elasticsearch-1.1.1 es-node3
cp -r elasticsearch-1.1.1 es-node4
cp -r elasticsearch-1.1.1 es-node5
cp -r elasticsearch-1.1.1 es-node6
cp -r elasticsearch-1.1.1 es-node7

cp /vagrant/elasticsearch.node1.yml es-node1/config/elasticsearch.yml
cp /vagrant/elasticsearch.node2.yml es-node2/config/elasticsearch.yml
cp /vagrant/elasticsearch.node3.yml es-node3/config/elasticsearch.yml
cp /vagrant/elasticsearch.node4.yml es-node4/config/elasticsearch.yml
cp /vagrant/elasticsearch.node5.yml es-node5/config/elasticsearch.yml
cp /vagrant/elasticsearch.node6.yml es-node6/config/elasticsearch.yml
cp /vagrant/elasticsearch.node7.yml es-node7/config/elasticsearch.yml

echo "Starting node 1"
es-node1/bin/elasticsearch -d

echo "Starting node 2"
es-node2/bin/elasticsearch -d

echo "Starting node 3"
es-node3/bin/elasticsearch -d

echo "Starting node 4"
es-node4/bin/elasticsearch -d

echo "Starting node 5"
es-node5/bin/elasticsearch -d

echo "Starting node 6"
es-node6/bin/elasticsearch -d

echo "Starting node 7"
es-node7/bin/elasticsearch -d

until curl -s localhost:9201
do
sleep 1
echo "Waiting ES node 1 to be up..."
done

until curl -s localhost:9202
do
sleep 1
echo "Waiting ES node 2 to be up..."
done

until curl -s localhost:9203
do
sleep 1
echo "Waiting ES node 3 to be up..."
done

until curl -s localhost:9204
do
sleep 1
echo "Waiting ES node 4 to be up..."
done

until curl -s localhost:9205
do
sleep 1
echo "Waiting ES node 5 to be up..."
done

until curl -s localhost:9206
do
sleep 1
echo "Waiting ES node 6 to be up..."
done

until curl -s localhost:9207
do
sleep 1
echo "Waiting ES node 7 to be up..."
done
