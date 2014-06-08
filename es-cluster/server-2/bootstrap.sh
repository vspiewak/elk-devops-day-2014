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

export JAVA_OPTS="$JAVA_OPTS -Djavax.management.builder.initial="
export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote"
export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=9010"
export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.local.only=false"
export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false"

cp /vagrant/log-generator.jar .

nohup java $JAVA_OPTS -jar log-generator.jar -n 10 -r 1000 > log-generator.nohup 2>&1 &
