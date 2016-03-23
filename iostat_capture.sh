#!/bin/bash

base=$[${1:-0}+1]
threads=${2:-16}
disk=`df | awk "/nvme$base$/ {print \\$1}"`
iostat -ytd $disk 1 >& /root/iostat-$base-$threads-`date +"%Y-%m-%d-%H-%M"` &
echo $! | tee /root/iostat-$base-$threads.pid
