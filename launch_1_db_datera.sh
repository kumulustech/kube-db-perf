#!/bin/bash

echo "Launcing test"
date +"%Y-%m-%d-%H-%M" > start-time.txt
ssh kube-minion-2 "rm iostat*"
scp iostat_capture_datera.sh kube-minion-2:iostat_capture.sh
screen -dmS mogodb_datera -c screen_rc_for_datera_1
