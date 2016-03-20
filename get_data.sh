#!/bin/bash

echo "DB,THREADS,READ_99,READ_95,UPDATE_99,UPDATE_95"
for m in `seq 22 3 55`
do
for n in 16 32 64 128
do
echo -n "$[$[$m-22]/3+1],$n,"
grep -e "\(READ\|UPDATE\).*\(99th\|95th\)" 10.0.0.$m-$n-threads.run.dat | awk -F', ' '{print $3}' | tr -s '\n' ','
grep "Throughput" 10.0.0.$m-$n-threads.run.dat | awk -F', ' '{print $3}' 
done
done
