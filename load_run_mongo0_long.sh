#!/bin/bash
cd /root/ycsb*
# if the environment has a $MONGO_ADDR parameter set use that
if [[ $# -le 0 ]]
then
  echo "you must pass the database replica you wish to run as in:"
  echo "    $0 0"
  echo "to run the scripts against the mongo0/1/2 database replica"
fi
n=$[${1:-0}]
MONGO_ADDR=10.0.0.$[$n*3+22]

./bin/ycsb load mongodb -threads 50 -s -P workloads/workloada -P /root/workload-mongo-perf-load -p mongodb.url=mongodb://${MONGO_ADDR}:27017/ycsb?w=0 -cp . | tee /root/${MONGO_ADDR}.load
for m in 16 32 64 96 128; do
./bin/ycsb run mongodb -threads ${m} -s -P workloads/workloada -P /root/workload-mongo-perf-run -p mongodb.url=mongodb://${MONGO_ADDR}:27017/ycsb?w=0 -cp . | tee /root/${MONGO_ADDR}-${m}-threads.run
done
