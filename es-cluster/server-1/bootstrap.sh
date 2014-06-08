#!/usr/bin/env bash

set -x

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

echo "Install flume"
curl -O http://mir2.ovh.net/ftp.apache.org/dist/flume/1.4.0/apache-flume-1.4.0-bin.tar.gz
tar xvzf apache-flume-1.4.0-bin.tar.gz
mv apache-flume-1.4.0-bin apache-flume

cp /vagrant/flume.conf apache-flume/conf
cp /vagrant/flume-env.sh apache-flume/conf
chmod a+x apache-flume/conf/flume-env.sh

echo "Starting flume"
cd /home/vagrant/apache-flume
nohup bin/flume-ng agent --name agent --conf conf -f conf/flume.conf > ../flume.nohup 2>&1 &
