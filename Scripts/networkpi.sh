#!/bin/bash
sudo ip addr add 192.168.2.1/24 dev enp0s20f0u1
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sudo iptables -t nat -A POSTROUTING -o wlp4s0 -j MASQUERADE
sudo iptables -A FORWARD -i wlp4s0 -o enp0s20f0u1 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i enp0s20f0u1 -o wlp4s0 -j ACCEPT

