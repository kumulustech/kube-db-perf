#!/bin/bash
for file in `ls *.run`
do
# mongo-1-pkt-nvme-1-128-threads.run
read db_type db_num target num_dbs threads <<<$( echo $file | sed -e 's/\(.*\)-\([0-9]*\)-\(.*\)-\([0-9]*\)-\([0-9]*\)-threads.run/\1 \2 \3 \4 \5 /') 
start_date=`grep '0 sec: 0 operations' $file | head -n 1 | sed -e 's/\(.*\):[0-9][0-9][0-9] 0 sec.*/\1/'`
start_sec=`date --date="$start_date" +"%s"`
echo "timestamp,OPS,operation_type,db_type,db_number,number_dbs,system_target,threads" > $db_type-$db_num-$target-$num_dbs-$threads.csv
grep '\[READ\]\|\[UPDATE\]' $file | while read line
do
read type sec ops <<<$( echo $line | tr ',' ' ' )
if [[ $sec =~ ^-?[0-9]+$ ]]; then
sec_new=$[${sec}/1000]
time=$[${start_sec}+${sec_new}]
if [[ "$type" == '[READ]' ]]
then 
  type=read
else
  type=update
fi
new_time=`date --date=\@$time +'%Y%h%d%H%M%S'`
echo "$new_time,$ops,$type,$db_type,$db_num,$num_dbs,$target,$threads" >> $db_type-$db_num-$target-$num_dbs-$threads.csv 
fi
done
done
