#!/bin/bash

#Get timeseries data out of the run data files
type=$1
for n in 10*$1*run
do
echo "TIME,OPS" > $n.csv
cat  $n | awk '/2016-/ {print $2","$7}' >> $n.csv 
done
