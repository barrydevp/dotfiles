#!/bin/sh
#
## Install:
#sudo apt-get install iptables-persistent
#
## Định nghĩa tên và IP cho card mạng nối ra ngoài Internet
EXT_IF="enp1s0"
EXT_IP="`ifconfig $EXT_IF | grep 'inet addr' | awk '{print $2}' | sed -e 's/.*://'`"

## Interface Loopback
LO_IF="lo"
LO_IP="127.0.0.1"

## Danh sách các dịch vụ cần mở
TCP_PORT="80,443,23456"
#LAN_PORT="25,389,636,873,9200,9300"
#UDP_PORT="16384:32768"

LAN_SUBNET="10.10.0.16/16"
#
## 1.5 IPTables Configuration.
#

IPT="iptables"

#
## Thiết đặt các chính sách

$IPT -F
$IPT -t nat -F
$IPT -X
$IPT -t nat -X

## Thiết lập luật mặc định là Xóa (DROP) tất cả các lối ra vào
$IPT -P INPUT   DROP
$IPT -P OUTPUT  DROP
$IPT -P FORWARD DROP

## Do some rudimentary anti-IP-spoofing drops. The rule of thumb is "drop
##  any source IP address which is impossible" (per RFC 1918)
##
#$IPT -A INPUT -s 255.0.0.0/8 -j LOG --log-prefix "Dai dia chi IP LUA DAO"
#$IPT -A INPUT -s 255.0.0.0/8 -j DROP
#$IPT -A INPUT -s 0.0.0.0/8 -j LOG --log-prefix "Dai dia chi IP LUA DAO"
#$IPT -A INPUT -s 255.0.0.0/8 -j DROP
#$IPT -A INPUT -s 0.0.0.0/8 -j LOG --log-prefix "Dai dia chi IP LUA DAO"
#$IPT -A INPUT -s 0.0.0.0/8 -j DROP
#$IPT -A INPUT -s 127.0.0.0/8 -j LOG --log-prefix "Dai dia chi IP LUA DAO"
#$IPT -A INPUT -s 127.0.0.0/8 -j DROP
#$IPT -A INPUT -s 172.16.0.0/12 -j LOG --log-prefix "Dai dia chi IP LUA DAO"
#$IPT -A INPUT -s 172.16.0.0/12 -j DROP

## The following will NOT interfere with local inter-process traffic, whose
##   packets have the source IP of the local loopback interface, e.g. 127.0.0.1

#$IPT -A INPUT -s $EXT_IP -j LOG --log-prefix "Dia chi IP LUA DAO"
#$IPT -A INPUT -s $EXT_IP -j DROP

## Tell netfilter that all TCP sessions do indeed begin with SYN
##   (There may be some RFC-non-compliant application somewhere which
##    begins its transactions otherwise, but if so I've never heard of it)

#$IPT -A INPUT -p tcp ! --syn -m state --state NEW -j LOG --log-prefix "Stealth scan attempt?"
#$IPT -A INPUT -p tcp ! --syn -m state --state NEW -j DROP


## Mở các cổng cho địa chỉ Loopback
$IPT -A INPUT   -j ACCEPT -i $LO_IF
$IPT -A OUTPUT  -j ACCEPT -o $LO_IF
$IPT -A FORWARD -j ACCEPT -i $LO_IF -o $LO_IF


## Cho phep Ping va gioi han so luong Ping
$IPT -A INPUT  -p icmp -m limit --limit 1/s --limit-burst 1 -j ACCEPT
$IPT -A INPUT  -p icmp -m limit --limit 1/s --limit-burst 1 -j LOG --log-prefix PING-DROP
$IPT -A INPUT  -p icmp -j DROP
$IPT -A OUTPUT -p icmp -j ACCEPT


## INTPUT: Mở các cổng cần thiết
#$IPT -A INPUT  -p tcp -m state --state NEW -i $EXT_IF -s $LAN_SUBNET -m multiport --dport $LAN_PORT -j ACCEPT
$IPT -A INPUT  -p tcp -m state --state NEW -i $EXT_IF -m multiport --dport $TCP_PORT -j ACCEPT
#$IPT -A INPUT  -p udp -m state --state NEW -i $EXT_IF -m multiport --dport $UDP_PORT -j ACCEPT


## OUTPUT: Mở các cổng cần thiết
$IPT -A OUTPUT -m state --state NEW -o $EXT_IF -j ACCEPT



## FORWARD: Mở các cổng cần thiết


## Mở đường cho tất cả kết nối đã được thiết lập
$IPT -A OUTPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A INPUT   -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

## Chuyen cong http (80) sang cong https(443)
#$IPT -A PREROUTING -t nat -i $EXT_IF -p tcp --dport 80 -j REDIRECT --to-port 443

## Save iptables voi Unbuntu 16.x
netfilter-persistent save

