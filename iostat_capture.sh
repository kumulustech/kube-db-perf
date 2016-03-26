#!/bin/bash

base=$[${1:-0}+1]
threads=${2:-16}
iscsiadm -m session >& /dev/null
if [[ $? -eq 0 ]]; then
disk=/dev/dm-$base
else
disk=`df | awk "/nvme$base$/ {print \\$1}"`
fi

iostat -cytd $disk 1 >& /root/iostat-1-$base-$threads-`date +"%Y-%m-%d-%H-%M"` &
echo -n $! | tee /root/iostat-1-$base-$threads.pid
iostat -cytd $disk 10 >& /root/iostat-10-$base-$threads-`date +"%Y-%m-%d-%H-%M"` &
echo -n $! | tee /root/iostat-$base-$threads.pid
