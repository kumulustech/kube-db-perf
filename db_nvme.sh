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
 ./mongo_manage_pod.sh stop ${db} ${offset} 
done
ssh minion rm -rf /mnt/nvme$[${db}+1]/*
for db in ${vals}
do 
 ./mongo_manage_pod.sh start ${db} ${offset} 
done
