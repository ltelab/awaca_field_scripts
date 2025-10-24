#!/bin/bash

while true; do
    dt=$(date '+%Y/%m/%d %H:%M:%S');
    num=$(echo Step | netcat 192.168.1.11 8082)
    echo "$dt : current power state $num "
    
    if [ "$num" -ge 3 ]; then
        echo "Shutting down "
        /sbin/shutdown -h now
    fi
    sleep 10
done
