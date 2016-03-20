#!/bin/bash

base=$[${0:-0}+1]
threads=${1:-16}
disk=`df | awk "/nvme$val$/ {print \$1}"`
iostat -ytd -p $disk >& /root/iostat-$base-$threads-`date +"%Y-%m-%d-%H-%M"` &
echo $! | tee /root/iostat-$base-$threads.pid
