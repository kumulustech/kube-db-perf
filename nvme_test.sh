#!/bin/bash
set -x
for i in 12 6 1
do
./${i}_db_nvme.sh
sleep 15
if [[$i -eq 12 ]]; then
vals=`seq 0 1 11`
elif [[ $i -eq 6 ]]; then
vals=`seq 0 2 11`
else
vals=1
fi
for n in ${vals}
do
./start_mongo.sh $n 1
done
./launch_db_nvme.sh ${i}
while [[ -f ./running ]]
do
echo date
sleep 3
done
done

