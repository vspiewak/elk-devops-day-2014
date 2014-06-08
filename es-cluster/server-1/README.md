
Listen to collectd packet sent over the network
-----------------------------------------------

sudo tcpdump -i eth1 -vv dst 192.168.1.10 and port 25826 and udp
sudo tcpdump -vv -i eth1 port 25826
