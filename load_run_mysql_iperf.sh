#!/bin/bash
set -x
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

./bin/ycsb load jdbc -P workloads/workloada -p db.driver=com.mysql.jdbc.Driver -p db.url=jdbc:mysql://${MONGO_ADDR}:3306/ycsb -p db.user=root -p db.passwd=admin -threads 128 -s -P /root/workload-mysql-perf-load -cp /usr/share/java/mysql-connector-java-5.1.28.jar:/usr/share/java:/root:.
for m in 16 32 64 96 128; do
pid=`ssh kube-minion-$[${offset}+1] "./iostat_capture.sh $n $m"`
./bin/ycsb run jdbc  -s -P workloads/workloada -P /root/workload-mongo-perf-run  -p db.driver=com.mysql.jdbc.Driver -p db.url=jdbc:mysql://${MONGO_ADDR}:3306/ycsb -p db.user=root -p db.passwd=admin -threads ${m} -cp /usr/share/java/mysql-connector-java-5.1.28.jar:/usr/share/java:/root:. -p exportmeasurementsinterval=1000 -p measurementtype=timeseries -p timeseries.granularity=1000 -p exportfile=/root/mysql-$[$n]-$3-${m}-threads.run
ssh kube-minion-$[${offset}+1] "kill $pid"
done
