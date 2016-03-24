#!/bin/bash
./mongo_manage_pod.sh stop 0 1
ssh kube-minion-2 rm -rf /mnt/nvme*/*
./mongo_manage_pod.sh start 0 1
