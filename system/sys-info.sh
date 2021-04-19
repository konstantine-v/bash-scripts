#!/bin/sh
#Minimal system info script for POSIX Shell, for use with servers to quickly check system info

case $OSTYPE in
    linux*)
        MACHINE=$(uname -m)
        KERNAL=$(uname -r)
        DATE=$(date +%Y-%m-%d)
        TIME=$(date +%H:%M)
        CPU=$(awk -F: '/^model name/ { mod=$2 } END { printf "%s",mod}' /proc/cpuinfo)
        MEM=$(grep -oP '(?<=MemTotal:        ).*(?= kB)' /proc/meminfo)
        FMEM=$(grep -oP '(?<=MemFree:        ).*(?= kB)' /proc/meminfo)
        IP=$(/sbin/ifconfig | grep 'inet ' | grep -v '127.0.0.1' | head -n1 | awk '{print $2}')

        printf "CPU:\t$CPU \n" ;
        printf "Mem:\t$FMEM kb/$MEM kb \n" ;
        printf "Arch:\t $MACHINE \n" ;
        printf "Kernal:\t Linux $KERNAL \n" ;
        printf "Date:\t $DATE \n" ;
        printf "Time:\t $TIME \n" ;
        printf "IP:\t $IP\n" ;;
  solaris* | darwin* | bsd* | *) echo "Not supported, create pull request if you want your system supported." ;;
esac
