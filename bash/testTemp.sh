#!/bin/bash

### Test temperatures for drives
while [ 0 == 0 ]
do
	echo `date` > /root/temperaturesTest
	for thing in `cat /root/portlist`;
	do
        	temp_str=`/usr/sbin/tw_cli $thing show temperature | xargs`;
        	celc=`echo $temp_str | cut -d' ' -f 4`;
        	temp_f=`echo $celc*9/5+32 | bc`;
        	both_temps=`echo "$temp_str ($temp_f in F)"`;
        	echo $both_temps >> /root/temperaturesTest;
	done;
	cat /root/temperaturesTest
	sleep 60s
done;
