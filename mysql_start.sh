#!/bin/bash
offset=${2:-0}
until mysql -h10.0.0.$[$1*3+20+${offset}] -uroot -padmin ycsb <<EOF
show tables;
EOF
do
 sleep 1
done
mysql -h10.0.0.$[$1*3+20+${offset}] -uroot -padmin ycsb < ycsb_create_table.sql
