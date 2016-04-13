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
  echo "will restart mysql9, mongo10, and mongo11"
  exit 1
fi

offset=${3:-0}
start_val=$[${2:-0}*3+${offset}]
if [[ ${1} != start ]]; then 
 kubectl delete svc mysql${start_val}
 kubectl delete pod mysql${start_val}
 sleep 5
fi
if [[ ${1} == restart ]]; then
 ssh minion-$[${offset}+1] rm -rf /mnt/nvme$[${start_val}/3+1]/*
fi
if [[ ${1} != stop ]]; then
echo $start_val
  ./mysql_db_create.sh ${2} ${offset}
  sleep 5
  ./mysql_start.sh ${2} ${offset}
fi

