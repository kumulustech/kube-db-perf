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
offset=${2:-2}
MONGO_ADDR=10.0.0.$[$n*3+20+$offset]

./bin/ycsb load mongodb -threads 50 -s -P workloads/workloada -P /root/workload-mongo-perf-load -p mongodb.url=mongodb://${MONGO_ADDR}:27017/ycsb?w=0 -cp .
for m in 16 32 64 96 128; do
pid=`ssh kube-minion-3 "./iostat_capture.sh $n $m"`
./bin/ycsb run mongodb -threads ${m} -s -P workloads/workloada -P /root/workload-mongo-perf-run  -p exportmeasurementsinterval=1000 -p measurementtype=timeseries -p timeseries.granularity=100 -p mongodb.readPreference=primary -p mongodb.url=mongodb://${MONGO_ADDR}:27017/ycsb?w=0 -cp . | grep -v DEBUG |& tee /root/${MONGO_ADDR}-$3-${m}-threads.run
ssh kube-minion-3 kill $pid
done
