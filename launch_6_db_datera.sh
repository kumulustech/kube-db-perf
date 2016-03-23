#!/bin/bash

echo "Launcing test"
date +"%Y-%m-%d-%H-%M" > start-time.txt
ssh kube-minion-2 rm iostat*
scp iostat_capture.sh kube-minion-2:
screen -dmS mogodb_test -c screen_rc_for_datera_6
