#!/bin/bash
set -x
base=$[${1:-0}+1]
threads=${2:-16}
iscsiadm -m session >& /dev/null
if [ $? ]; then
disk=`df | awk "/nvme$base$/ {print \\$1}"`
minor=`ls -l $disk | awk '/252/ {print $6}'`
disk=/dev/dm-$minor
else
disk=`df | awk "/nvme$base$/ {print \\$1}"`
fi
iostat -cxytd $disk 1 >& /root/iostat-1-$base-$threads-`date +"%Y-%m-%d-%H-%M"` &
echo -n $! | tee /root/iostat-1-$base-$threads.pid
echo -n ' '
iostat -cxytd $disk 10 >& /root/iostat-10-$base-$threads-`date +"%Y-%m-%d-%H-%M"` &
echo -n $! | tee /root/iostat-$base-$threads.pid
