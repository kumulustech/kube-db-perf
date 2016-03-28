#!/bin/bash

offset=${2:-0}
n=$[$1*3+${offset}]
cat mysql-nvme.json.tmpl | sed -e "s/DB_NUMBER/${n}/" -e "s,VOL_NUMBER,$[${n}/3+1]," -e "s/DB_TARGET/sql-minion-$[${offset}+1]/" | kubectl create -f -
cat mysql-svc.json.tmpl | sed -e "s/DB_NUMBER/${n}/" -e "s/DB_CLUSTER_IP/$[${n}+20]/" | kubectl create -f -

