#!/bin/bash
for n in `seq 0 2 10`
do
 ./mongo_manage_pod.sh stop $n 0
done
ssh kube-minion-1 rm -rf /mnt/nvme*/*
for n in `seq 0 2 10`
do 
 ./mongo_manage_pod.sh start $n 0
done
