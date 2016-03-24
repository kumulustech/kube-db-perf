#!/bin/bash
./mysql_manage_pod.sh stop 0 1
ssh kube-minion-2 "rm -rf /mnt/nvme*/*"
ssh kube-minion-2 "mkdir /mnt/config/"
scp config-file.cnf kube-minion-2:/mnt/config/config-file.cnf
./mysql_manage_pod.sh start 0 1
