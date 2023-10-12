#!/bin/bash
# enp0s20f0u4
# mkdir /home/dxt0r/.cache
while true
do
    conn=$(ls /sys/class/net | grep -i "enp0s")
    lastrx=$(cat /sys/class/net/$conn/statistics/rx_bytes)
    lasttx=$(cat /sys/class/net/$conn/statistics/tx_bytes)
    sleep 1
    expr $(cat /sys/class/net/$conn/statistics/rx_bytes) - $lastrx | awk '{print $1 * 10^-3}' > /home/dxt0r/.cache/netrx
    expr $(cat /sys/class/net/$conn/statistics/tx_bytes) - $lasttx | awk '{print $1 * 10^-3}' > /home/dxt0r/.cache/nettx
done