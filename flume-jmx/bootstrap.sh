#!/usr/bin/env bash

rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

apt-get update

apt-get install -y curl

echo "Install JDK 7"
apt-get install -y openjdk-7-jdk
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

ln -s /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server/libjvm.so /usr/lib/libjvm.so

apt-get install -y collectd
cp /vagrant/collectd.conf /etc/collectd/

echo "jmx_memory              value:GAUGE:0:U" >> /usr/share/collectd/types.db

/etc/init.d/collectd restart


apt-get install -y nginx
/etc/init.d/nginx restart

wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.tar.gz
tar xvzf logstash-1.4.0.tar.gz
cp /vagrant/logstash.conf logstash-1.4.0/

wget https://download.elasticsearch.org/kibana/kibana/kibana-3.0.1.tar.gz
tar xvzf kibana-3.0.1.tar.gz
mv kibana-3.0.1 /usr/share/nginx/www/kibana
cp /vagrant/kibana.config.js /usr/share/nginx/www/kibana/config.js

wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz
tar xvzf elasticsearch-1.1.1.tar.gz

elasticsearch-1.1.1/bin/plugin -install mobz/elasticsearch-head
elasticsearch-1.1.1/bin/plugin -install lukas-vlcek/bigdesk
elasticsearch-1.1.1/bin/plugin -install karmi/elasticsearch-paramedic

mv elasticsearch-1.1.1 elasticsearch

echo "Install flume"
curl -O http://mir2.ovh.net/ftp.apache.org/dist/flume/1.4.0/apache-flume-1.4.0-bin.tar.gz
tar xvzf apache-flume-1.4.0-bin.tar.gz
mv apache-flume-1.4.0-bin apache-flume

cp /vagrant/flume.conf apache-flume/conf
cp /vagrant/flume-env.sh apache-flume/conf
chmod a+x apache-flume/conf/flume-env.sh

echo "Starting elasticsearch"
elasticsearch/bin/elasticsearch -d

until curl -s localhost:9200
do
  sleep 1
  echo "Waiting ES to be up..."
done

echo "Starting logstash"
cd logstash-1.4.0
nohup bin/logstash agent -f logstash.conf > ../logstash.nohup &

echo "Starting flume"
cd /home/vagrant/apache-flume
nohup bin/flume-ng agent --name agent --conf conf -f conf/flume.conf > ../flume.nohup &
