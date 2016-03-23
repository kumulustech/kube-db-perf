#!/bin/bash
for n in `seq 0 2 10`
do
 ./mongo_manage_pod.sh stop $n 1
done
ssh kube-minion-2 rm -rf /mnt/nvme*/*
for n in `seq 0 2 10`
do 
 ./mongo_manage_pod.sh start $n 1
done
