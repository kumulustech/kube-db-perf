#!/bin/bash
touch running
scale=${1:-12}
echo "Launching test $1"
date +"%Y-%m-%d-%H-%M" > start-time.txt
ssh kube-minion-1 "rm iostat*"
scp iostat_capture.sh kube-minion-1:
screen -dmS mogodb_nvme -c screen_rc_for_${scale}_nvme
date +"%Y-%m-%d-%H-%M" > stop-time.txt
mkdir -p ${scale}_db_$(cat stop-time.txt)/nvme/{iostat,csv,run}
scp kube-minion-1:iostat-* ${scale}_db_$(cat stop-time.txt)/nvme/iostat
pushd ${scale}_db_$(cat stop-time.txt)/nvme/iostat
rm *.pid
~/iostat_clean.sh
mv *.csv ../csv/
popd
mv 10*run ${scale}_db_$(cat stop-time.txt)/nvme/run
pushd ${scale}_db_$(cat stop-time.txt)/nvme/run
~/get_rw_ts.sh
mv *.csv ../csv/
popd
rm running
