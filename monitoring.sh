#!/bin/bash

# Architecture
arch=$(uname -m)

# CPU Info
cpuf=$(grep -c "physical id" /proc/cpuinfo)
cpuv=$(grep -c "processor" /proc/cpuinfo)

# RAM
ram=$(free --mega | awk '/Mem:/ {printf("%d/%dMB (%.2f%%)", $3, $2, $3/$2*100)}')

# Disk
disk=$(df -m --total | awk '/^total/ {printf("%.1fGb/%.1fGb (%d%%)", $3/1024, $2/1024, $3/$2*100)}')

# CPU Load
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf("%.1f%%", 100 - $15)}')

# Last Boot
last_boot=$(who -b | awk '{print $3, $4}')

# LVM Use
lvm_use=$(lsblk | grep -q "lvm" && echo "yes" || echo "no")

# TCP Connections
tcp_conn=$(ss -ta | grep -c ESTAB)

# User Log
user_log=$(users | wc -w)

# Network Info
network=$(printf "IP %s (%s)" "$(hostname -I)" "$(ip link | awk '/ether/ {print $2}')")

# Sudo Commands
sudo_cmd=$(journalctl _COMM=sudo | grep -c COMMAND)

# Output
wall "  Architecture: $arch
        CPU physical: $cpuf
        vCPU: $cpuv
        Memory Usage: $ram
        Disk Usage: $disk
        CPU load: $cpu_load
        Last boot: $last_boot
        LVM use: $lvm_use
        Connections TCP: $tcp_conn ESTABLISHED
        User log: $user_log
        Network: $network
        Sudo: $sudo_cmd cmd"
