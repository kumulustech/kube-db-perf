#!/bin/bash
./mongo_manage_pod.sh stop 0 0
ssh kube-minion-1 rm -rf /mnt/nvme*/*
./mongo_manage_pod.sh start 0 0
