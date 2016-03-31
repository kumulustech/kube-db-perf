#!/bin/bash
num_dbs=${1:-1}
db_type=${2:-mongo}
proj=${3:-packet-nvme}
for n in `ls ./iostat-*`
do
  read interval db threads <<<$(echo ${n} | sed -e 's/.*iostat-\([0-9]*\)-\([0-9]*\)-\([0-9]*\)-[0-9].*/\1 \2 \3/')
  echo timestamp,db_type,project,num_dbs,db_num,iostat-int,threads,%user,%nice,%system,%iowait,%steal,%idle,device,rrqm_s,wrqm_s,r_s,w_s,rkB_s,wkB_s,avgrq-sz,avgqu-sz,await,r_await,w_await,svctm,pct_util > $n.csv
  cat $n | grep -v '^Linux\|^$\|avg-cpu\|^Device' | sed -e ':a;$!N;s/\([AP]M\)\n/\1,/;ta;P;D' | sed -e ':a;$!N;s/\([0-9][0-9]\)\n\(nvme.*\)[[:space:]]/\1,\2,/;ta;P;D' | sed -e ':a;$!N;s/\([0-9][0-9]\)\n\(dm-.*\)[[:space:]]/\1,\2,/;ta;P;D' | sed -e 's/[[:space:]]\+/,/g' -e 's/,,/ /g' | sed -e "s/^\(.*\),\(.*\),\([AP]M\) /\1 \2 \3,$db_type,$proj,$num_dbs,$db,$interval,$threads,/" >> $n.csv
done

