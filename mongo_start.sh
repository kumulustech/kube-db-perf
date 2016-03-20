#!/bin/bash
if [[ $# -le 0 ]]; then
  echo "This tool expects an argument specifying the starting value"
  echo "of the POD name to which 20 will be added as the address for"
  echo "the Service CLUSTER_IP of 10.0.0.X, where X starts at 20"
  echo "the script takes a value from 1..n"
  echo "a second parameter can be added, which is the number of databases"
  echo "a third parameter adds a delta to the addresses, to place the instance"
  echo "on a specific node (0,1, or 2)"
  echo "For example:"
  echo "    $0 0"
  echo "will use 20 as the primary, and create one database"
  echo "    $0 2 6 2"
  echo "will start with addr 29, and initialize 5 more databases"
fi
n=${1:-0}
m=${2:-1}
o=$[${3:-0}]
mongo 10.0.0.$[$n*3+20+$o] <<EOF
rs.initiate()
EOF
