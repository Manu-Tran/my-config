#!/bin/bash
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sudo iptables -t nat -A POSTROUTING -o wlp4s0 -j MASQUERADE
sudo iptables -A FORWARD -i wlp4s0 -o $1 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $1 -o wlp4s0 -j ACCEPT

