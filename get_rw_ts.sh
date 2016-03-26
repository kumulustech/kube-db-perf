#!/bin/bash

#Get timeseries data out of the run data files
type=$1
for n in *$1*run
do
echo "OP,TIME,OPS" > $n.csv
grep '\[READ\]\|\[UPDATE\]'  $n >> $n.csv 
done
