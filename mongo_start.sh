#!/bin/bash
offset=${2:-2}
addr=10.0.0.$[$1*3+20+${offset}]
until [[ `echo "rs.status()" | mongo $addr | tail -n 1` =~ bye ]]; do
sleep 5
done
echo "rs.initiate()" | mongo $addr
