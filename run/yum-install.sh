#!/usr/bin/env bash

# Update centos version and packages
yum update -y

yum install -y vim
yum install -y tmux
yum install -y yum-utils

yum install -y zip
yum install -y unzip
yum install -y p7zip    # 7za

yum install -y ftp
yum install -y traceroute
# yum install -y netcat

# epel-release

yum install -y epel-release
yum install -y htop
yum install -y lm_sensors

# Dev tools 
yum install -y git
yum install -y gcc
yum install -y gdb
yum install -y cmake

# Net Tools
yum install -y nmap
yum install -y net-tools
yum install -y telnet
yum install -y tcpdump
yum install -y bind-utils   # nslookup
# netstat
# arp, arping
# ifconfig
# fping

# python related
yum install -y python34
yum install -y python-virtualenv
yum install -y python2-pip
yum install -y python34-pip

yum install -y wget

yum install -y gcc-c++
# others
# m4, gcc lastest version
# docker, mysql, mongodb
