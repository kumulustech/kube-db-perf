#!/bin/bash
for n in `ls ./iostat-*`
do
  echo $n
  echo date,time,am,%user,%nice,%system,%iowait,%steal,%idle,device,tps,kB_read/s,kB_wrtn/s,kB_read,kB_wrtn > $n.csv
  cat $n | grep -v '^Linux\|^$\|avg-cpu\|^Device' | sed -e ':a;$!N;s/\([AP]M\)\n/\1,/;ta;P;D' -e ':a;$!N;s/\([0-9][0-9]\)\n\(nvme.*\)[[:space:]]/\1,\2,/;ta;P;D' | sed -e 's/[[:space:]]\+/,/g' -e 's/,,/,/g' >> $n.csv
done

