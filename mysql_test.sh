#!/bin/bash
set -x
offset=${1:-0}
for vals in 12 6 4 2 1
do
./launch_db_mysql.sh ${vals}
done

