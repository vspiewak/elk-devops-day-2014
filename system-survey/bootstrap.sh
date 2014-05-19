#!/usr/bin/env bash

rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

apt-get update

apt-get install -y curl

apt-get install -y openjdk-7-jre-headless

apt-get install -y collectd
cp /vagrant/collectd.conf /etc/collectd/
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

#cp /vagrant/elasticsearch.node1.yml es-node1/config/elasticsearch.yml

echo "starting elasticsearch"
elasticsearch/bin/elasticsearch -d

until curl -s localhost:9200
do
  sleep 1
  echo "Waiting ES to be up..."
done

echo "starting logstash"
cd logstash-1.4.0
nohup bin/logstash agent -f logstash.conf > ../logstash.nohup &

curl -XPOST localhost:9200/kibana-int/dashboard/Collectd --data-binary @/vagrant/dashboard.json
cp /vagrant/dashboard.json /usr/share/nginx/www/kibana/app/dashboards/custom.json
