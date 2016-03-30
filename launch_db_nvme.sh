#!/bin/bash
scale=${1:-12}
offset=${2:-0}
date=`date +%Y%m%d%H%M`
echo "Launching test with ${scale} databases ${date}" | tee -a running-time.txt
echo "First we ensure our databases are clean"
./db_nvme.sh $scale
echo "then we clean up any previous iostat info"
ssh kube-minion-$[${offset}+1] "rm iostat*"
scp iostat_capture.sh kube-minion-$[${offset}+1]:
echo "and then we launch our test in a screen session"
screen -dmS mogodb_nvme -c screen_rc_for_${scale}_nvme
sleep 30
until [[ `ps -e | grep java | wc -l` -eq 0 ]]
do
sleep 30
echo -n '.'
done
date=`date +%Y%m%d%H%M`
echo "Finished testing ${scale} databases on ${date}" | tee -a running-time.txt
mkdir -p ${scale}_db_${date}/nvme/{iostat,csv,run}
cd ${scale}_db_${date}/nvme/iostat
scp kube-minion-1:iostat-* .
rm *.pid
~/iostat_clean.sh
mv *.csv ../csv/
cd ../run
mv ~/10*run .
~/get_rw_ts.sh
mv *.csv ../csv/
cd
