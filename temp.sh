#!/bin/bash

while true;do
	cat /sys/class/thermal/thermal_zone0/temp
    sleep 1
done
