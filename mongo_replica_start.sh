#!/bin/bash
if [[ $# -le 0 ]]; then
  echo "This tool expects an argument specifying the starting value"
  echo "of the POD name to which 20 will be added as the address for"
  echo "the Service CLUSTER_IP of 10.0.0.X, where X starts at 20"
  echo "the script takes a value from 1..n and does modulo 3 math"
  echo "to spread the initial primary across the environment"
  echo ""
  echo "For example:"
  echo "    $0 0"
  echo "will use 20 as the primary, 21 and 22 will be secondary"
  echo "    $0 2"
  echo "will use 27 as the primary, and 26 and 28 as the secondary"
fi
n=$[${1:-0}]

if [[ $[${n}%3] -eq 0 ]]
then
master=0
sec=1
thi=2
elif [[ $[${n}%3] -eq 1 ]]
then
master=1
sec=0
thi=2
else [[ $[${n}%3] -eq 2 ]]
master=2
sec=1
thi=0
fi

#$[$master+$n*3] $[$sec+$n*3] $[$thi+$n*3]

mongo 10.0.0.$[$master+$n*3+20] <<EOF
rs.initiate()
rs.add("mongo$[$sec+$n*3]")
rs.add("mongo$[$thi+$n*3]")
EOF
sleep 5
mongo 10.0.0.$[$master+$n*3+20] <<EOF
rs.status()
EOF
