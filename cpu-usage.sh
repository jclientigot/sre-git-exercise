#!/bin/bash

CPU_UTIL=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | awk '{printf "%.0f\n", $1}')
TIMESTAMP=$(date ' +%Y-%m-%d_$H:%M:%S')
LOG_FILE="/var/log/cpu-monitor.log"
if [ "$CPU_UTIL" -lt 80 ]; then
	STATUS="OK"
	EXIT_CODE=0
elif [ "$CPU_UTIL" -lt 90 ]; then
	STATUS="WARNING"
        EXIT_CODE=1
else
	STATUS="CRITICAL"
	EXIT_CODE=2
fi
echo "$TIMESTAMP - $STATUS - ${CPU_UTIL}%" >> "$LOG_FILE"
exit $EXIT_CODE
echo "Healthcheck run at: $(date)"
echo ""
echo "Top 5 CPU-consuming processes:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
