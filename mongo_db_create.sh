#!/bin/bash

if [[ $# -le 0 ]]; then
echo "You need to pass the database node to start at and"
echo "the number of databases to create (default is 3)"
echo "The system assumes mod 3 target hosts, and will "
echo "allocate round robin (e.g. db# mod 3 minion)"
exit 1
fi

start_val=${1:-0}
num_dbs=${2:-3}

for n in `seq ${start_val} $[${start_val}+${num_dbs}-1]`
do
 cat mongo-nvme.json.tmpl | sed -e "s/DB_NUMBER/${n}/" -e "s,VOL_NUMBER,$[${n}/3+1]," -e "s/DB_TARGET/kube-minion-$[${n}%3+1]/" | kubectl create -f -
 cat mongo-svc.json.tmpl | sed -e "s/DB_NUMBER/${n}/" -e "s/DB_CLUSTER_IP/$[${n}+20]/" | kubectl create -f -
done

