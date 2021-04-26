#!/usr/bin/env bash

if ! command -v iptables > /dev/null
then
	echo "need iptables command installed"
	exit 1
fi

if [ "$#" -lt 2 ]; then
	echo "disconnect Spread hosts from Docker network to simulate partitions"
	echo "$0 status|connect|disconnect <host> ..."
	exit 1
fi

[ $(whoami) == "root" ] || exec sudo "$0" "$@"

op=$1

shift

for host in $*
do

echo -n "$host: "

ip=$(docker network inspect -f '{{range .Containers}}{{.Name}} {{println .IPv4Address}}{{end}}'  spread_default  | cut -d/ -f1 | grep $host | cut -d" " -f2 )

if [ "x" == "${ip}x" ]
then
	echo "not found"
	continue
fi

echo -n "$ip: "

if [ $op == "connect" ]
then
	if iptables -S DOCKER-USER | grep $ip | grep 4803:4804 > /dev/null
	then
		iptables -D DOCKER-USER -p udp -d $ip/32 --dport 4803:4804 -j DROP
		echo "connected"
	else
		echo "already connected"
	fi
elif [ $op == "disconnect" ]
then
	if iptables -S DOCKER-USER | grep $ip | grep 4803:4804 > /dev/null
	then
		echo "already disconnected"
	else
		iptables -I DOCKER-USER -p udp -d $ip/32 --dport 4803:4804 -j DROP
		echo "disconnected"
	fi
elif [ $op == "status" ]
then
	if iptables -S DOCKER-USER | grep $ip | grep 4803:4804 > /dev/null
	then
		echo "disconnected"
	else
		echo "connected"
	fi
else
	echo "invalid operation $op"
	exit 1
fi

done

exit 0
