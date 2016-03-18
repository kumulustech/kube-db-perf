#!/bin/bash
if [[ $# -le 0 ]]; then
  echo "This tool expects an argument specifying the starting value"
  echo "of the POD name.  It expects the number of the replication set"
  echo "e.g. from 0 to 11. It also expects an action"
  echo "supported actions are start, stop and restart. If no replica set"
  echo "value is given 0 is assumed.  An action is required"
  echo ""
  echo "For example:"
  echo "    $0 start 3"
  echo "will restart mongo9, mongo10, and mongo11"
  exit 1
fi

start_val=$[${2:-0}*3]
if [[ ${1} != start ]]; then 
  for n in `seq ${start_val} $[${start_val}+2]`
  do
    kubectl delete svc mongo${n}
    kubectl delete pod mongo${n}
    sleep 5
  done
fi
if [[ ${1} == restart ]]; then
for n in `seq ${start_val} $[${start_val}+2]`
do
  for m in {1..3}
  do
    ssh kube-minion-${m} rm -rf /mnt/nvme${n}/*
    sleep 2
  done
done
fi
if [[ ${1} != stop ]]; then
  ./mongo_db_create.sh ${start_val} 3
  sleep 2
  ./mongo_replica_start.sh $[${start_val}/3]
fi

