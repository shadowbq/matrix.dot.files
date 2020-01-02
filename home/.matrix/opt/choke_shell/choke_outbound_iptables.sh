#!/bin/sh
#only allow apps run from "internet" group to run

# clear previous rules
sudo iptables -F

# accept packets for internet group
sudo iptables -A OUTPUT -p tcp -m owner --gid-owner choke -j ACCEPT
sudo iptables -A OUTPUT -p udp -m owner --gid-owner choke -j ACCEPT
#Some application need more port. Such as ping.
sudo iptables -A OUTPUT -p icmp -m owner --gid-owner choke -j ACCEPT
#Less secure. Open all port.
#sudo iptables -A OUTPUT -m owner --gid-owner choke -j ACCEPT

# also allow local connections
#TODO. Use log to see which port are actually needed.
sudo iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT
sudo iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT
sudo iptables -A OUTPUT -d 172.16.0.0/12 -j ACCEPT
sudo iptables -A OUTPUT -d 10.0.0.0/8 -j ACCEPT

# reject packets for other users
sudo iptables -A OUTPUT -j REJECT

#Allow DNS DHCP and NTP Global
sudo iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p udp -m udp --dport 67 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 67 -j ACCEPT
sudo iptables -A INPUT -p udp -m udp --dport 123 -j ACCEPT

#ONLY ACCEPTS INPUT THAT WAS INITIATED BY SOME OUTPUT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#DROPS ALL INPUT and FORWARD
sudo iptables -A INPUT -j DROP
sudo iptables -A FORWARD -j DROP


#IPv6 Section

# Flush ip6tables too
sudo ip6tables -F

# same process for IPv6:
sudo ip6tables -A OUTPUT -p tcp -m owner --gid-owner choke -j ACCEPT
sudo ip6tables -A OUTPUT -p udp -m owner --gid-owner choke -j ACCEPT
sudo ip6tables -A OUTPUT -d ::1/128 -j ACCEPT
sudo ip6tables -A OUTPUT -d fe80::/10 -j ACCEPT
sudo ip6tables -A OUTPUT -j REJECT

sudo ip6tables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
sudo ip6tables -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
sudo ip6tables -A INPUT -p udp -m udp --dport 67 -j ACCEPT
sudo ip6tables -A INPUT -p tcp -m tcp --dport 67 -j ACCEPT
sudo ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo ip6tables -A INPUT -j DROP
sudo ip6tables -A FORWARD -j DROP

echo "Firewall is choking all outbound data not created from 'choke' GID"
echo "Run choke_shell"
