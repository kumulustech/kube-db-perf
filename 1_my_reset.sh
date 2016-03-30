#!/bin/bash
./mysql_manage_pod.sh stop 0
ssh sql-minion-3 rm -rf /mnt/nvme*/*
./mysql_manage_pod.sh start 0
