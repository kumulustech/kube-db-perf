#!/bin/bash
launch_dir=${PWD}
scale=${1:-12}
offset=${2:-2}
date=`date +%Y%m%d%H%M`
echo "Launching test with ${scale} databases ${date}" | tee -a running-time.txt
echo "First we ensure our databases are clean"
./db_mysql.sh $scale
echo "then we clean up any previous iostat info"
ssh sql-minion-$[${offset}+1] "rm iostat*"
scp iostat_capture.sh sql-minion-$[${offset}+1]:
echo "and then we launch our test in a screen session"
screen -dmS mysql_nvme_${scale} -c screen_rc_for_my_${scale}
sleep 30
until [[ `ps -e | grep java | wc -l` -eq 0 ]]
do
sleep 30
echo -n '.'
done
date=`date +%Y%m%d%H%M`
echo "Finished testing ${scale} databases on ${date}" | tee -a running-time.txt
mkdir -p ${scale}_my_${date}/nvme/{iostat,csv,run}
cd ${scale}_my_${date}/nvme/iostat
scp sql-minion-3:iostat-* .
rm *.pid
$launch_dir/iostat_clean.sh
mv *.csv ../csv/
cd ../run
mv ~/mysql*run .
$launch_dir/get_rw_ts.sh
mv *.csv ../csv/
cd $launch_dir
tar cfz ~/${scale}_my_${date}.tgz $launch_dir/${scale}_my_${date}/
