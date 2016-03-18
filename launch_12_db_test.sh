#!/bin/bash

echo "Launcing test"
time | tee start-time.txt
for n in {1..3}
do
  ssh kube-minion-${n} "iostat 30 >& iostat_minion_${n}" &
done

screen -dmS mogodb_test -c screen_rc_for_logs
