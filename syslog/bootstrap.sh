#!/usr/bin/env bash

echo "Set Europe/Paris timezone"
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

echo "Update system"
apt-get update

echo "Install utilities"
apt-get install -y curl

echo "Install JDK 7"
apt-get install -y openjdk-7-jre-headless

echo "Install Nginx"
apt-get install -y nginx
/etc/init.d/nginx restart

echo "Install Logstash"
curl -O https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.tar.gz
tar xvzf logstash-1.4.0.tar.gz

cp /vagrant/GeoLiteCity.dat .
cp /vagrant/logstash.conf .
cp -r /vagrant/patterns .

echo "Install Elasticsearch"
curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz
tar xvzf elasticsearch-1.1.1.tar.gz

echo "Install Elasticsearch plugins"
elasticsearch-1.1.1/bin/plugin -install mobz/elasticsearch-head
elasticsearch-1.1.1/bin/plugin -install lukas-vlcek/bigdesk
elasticsearch-1.1.1/bin/plugin -install karmi/elasticsearch-paramedic

mv elasticsearch-1.1.1 elasticsearch

echo "Install Kibana"
curl -O https://download.elasticsearch.org/kibana/kibana/kibana-3.0.1.tar.gz
tar xvzf kibana-3.0.1.tar.gz
mv kibana-3.0.1 /usr/share/nginx/www/kibana
cp /vagrant/kibana.config.js /usr/share/nginx/www/kibana/config.js
cp /vagrant/dashboard.syslog.json /usr/share/nginx/www/kibana/app/dashboards/syslog.json

echo "Install log-generator"
cp /vagrant/log-generator.jar .

echo "Starting elasticsearch"
elasticsearch/bin/elasticsearch -d

until curl -s localhost:9200
do
  sleep 1
  echo "Waiting ES to be up..."
done

echo "Starting log generator"
nohup java -jar log-generator.jar -n 10 -r 1000 -e > log-generator.nohup &

echo "Starting logstash"
#cd logstash-1.4.0
nohup logstash-1.4.0/bin/logstash agent -f logstash.conf > logstash.nohup &
