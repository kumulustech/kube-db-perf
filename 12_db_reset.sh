#!/bin/bash
for n in `seq 0 1 11`
do
 ./mongo_manage_pod.sh stop $n
done
ssh kube-minion-3 rm -rf /mnt/nvme*/*
for n in `seq 0 1 11`
do 
 ./mongo_manage_pod.sh start $n
done
