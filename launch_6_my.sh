#!/bin/bash

echo "Launcing test"
date +"%Y-%m-%d-%H-%M" > start-time.txt
ssh kube-minion-3 "rm iostat*"
scp iostat_capture.sh kube-minion-3:
screen -dmS mysql_test_6 -c screen_rc_for_my_6
