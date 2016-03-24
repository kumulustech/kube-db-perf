#!/bin/bash

echo "Launcing test"
date +"%Y-%m-%d-%H-%M" > start-time.txt
ssh kube-minion-1 "rm iostat*"
scp iostat_capture.sh kube-minion-1:
screen -dmS mogodb_nvme -c screen_rc_for_1_nvme
