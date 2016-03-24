#!/bin/bash

echo "Launcing test"
date +"%Y-%m-%d-%H-%M" > start-time.txt
ssh kube-minion-3 "rm iostat*"
scp iostat_capture.sh kube-minion-3:

screen -dmS mogodb_test -c screen_rc_for_logs
