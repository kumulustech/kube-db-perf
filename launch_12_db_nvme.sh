#!/bin/bash

echo "Launcing test"
date +"%Y-%m-%d-%H-%M" > start-time.txt
ssh kube-minion-1 "rm iostat*"
scp iostat_capture.sh kube-minion-1:
screen -dmS mogodb_nvme -c screen_rc_for_12_nvme
date +"%Y-%m-%d-%H-%M" > stop-time.txt
mkdir -p 12_db_$(cat stop-time.txt)/nvme/{iostat,csv,run}
scp kube-minion-1:iostat-* 12_db_$(cat stop-time.txt)/nvme/iostat
mv 10*run 12_db_$(cat stop-time.txt)/nvme/run
