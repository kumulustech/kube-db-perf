#!/bin/bash
./mongo_manage_pod.sh stop 0
ssh kube-minion-3 rm -rf /mnt/nvme*/*
./mongo_manage_pod.sh start 0
