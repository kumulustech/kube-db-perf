#!/bin/bash
set -x
scale=${1:-12}
offset=${2:-0}
if [[ $scale -eq 12 ]]; then
vals=`seq 0 1 11`
elif [[ $scale -eq 6 ]]; then
vals=`seq 0 2 11`
elif [[ $scale -eq 4 ]]; then
vals=`seq 0 3 11`
elif [[ $scale -eq 2 ]]; then
vals='0 6'
else
vals='0'
fi
for db in ${vals}
do
 ./mysql_manage_pod.sh stop ${db} ${offset} 
done
# we only load the database once and then manually replicate
# to the other nodes due to the length of time needed
# to load the database the first time
#ssh minion-$[${offset}+1] rm -rf /mnt/nvme$[${db}+1]/*
for db in ${vals}
do 
 ./mysql_manage_pod.sh start ${db} ${offset} 
done
