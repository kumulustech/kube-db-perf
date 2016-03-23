#!/bin/bash

offset=${2:-2}
n=$[$1*3+${offset}]
cat mongo-nvme.json.tmpl | sed -e "s/DB_NUMBER/${n}/" -e "s,VOL_NUMBER,$[${n}/3+1]," -e "s/DB_TARGET/kube-minion-$[${offset}+1]/" | kubectl create -f -
cat mongo-svc.json.tmpl | sed -e "s/DB_NUMBER/${n}/" -e "s/DB_CLUSTER_IP/$[${n}+20]/" | kubectl create -f -

