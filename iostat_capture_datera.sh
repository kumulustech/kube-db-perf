#!/bin/bash

base=$[${1:-0}]
threads=${2:-16}
disk=/dev/dm-$base
iostat -cytd $disk 1 >& /root/iostat-$base-$threads-`date +"%Y-%m-%d-%H-%M"` &
echo $! | tee /root/iostat-$base-$threads.pid
