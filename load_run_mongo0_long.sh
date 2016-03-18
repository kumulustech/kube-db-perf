#!/bin/bash
cd /root/ycsb*
# if the environment has a $MONGO_ADDR parameter set use that
MONGO_ADDR=${MONGO_ADDR:-10.0.0.20}

./bin/ycsb load mongodb -threads 50 -s -P workloads/workloada -P /root/workload-mongo-perf-load -p mongodb.url=mongodb://${MONGO_ADDR}:27017/ycsb?w=majority | tee /root/${MONGO_ADDR}.load
for n in 16 32 64 128; do
./bin/ycsb run mongodb -threads ${n} -s -P workloads/workloada -P /root/workload-mongo-perf-run -p mongodb.url=mongodb://${MONGO_ADDR}:27017/ycsb?w=majority | tee /root/${MONGO_ADDR}-${n}-threads.run
done
