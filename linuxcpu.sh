#!/bin/bash

THRESHOLD=2
TO_EMAIL="trietreeinfo@gmail.com"

while true
do
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | \
        sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
        awk '{print 100 - $1}')
    if (( $(echo "$CPU_USAGE > $THRESHOLD" |bc -l) )); then
        echo "High CPU usage detected: $CPU_USAGE%"
        echo "Sending email to $TO_EMAIL"
        echo "High CPU usage detected: $CPU_USAGE%" | mail -s "High CPU usage alert" "$TO_EMAIL"
    fi
    sleep 60
done
