#!/bin/bash

echo "Launcing test"
date +"%Y-%m-%d-%H-%M" > start-time.txt
#for n in {1..3}
#do
#  ssh kube-minion-${n} "iostat 30 >& iostat_minion_${n}" &
#done
ssh kube-minion-3 "iostat -p /dev/nvme0n1 -p /dev/nvme1n1 30 >& iostat_minion_$(date +"%Y-%m-%d")" &

screen -dmS mogodb_test -c screen_rc_for_logs
