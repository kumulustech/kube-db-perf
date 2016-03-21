#!/bin/bash

base=$[${1:-0}+1]
threads=${2:-16}
disk=`df | awk "/nvme$val$/ {print \$1}"`
iostat -ytd -p $disk 1 >& /root/iostat-$base-$threads-`date +"%Y-%m-%d-%H-%M"` &
echo $! | tee /root/iostat-$base-$threads.pid
