#!/bin/bash
set -x
offset=${1:-2}
for vals in 1 2 4 6 12
do
for scale in ${vals}
do
./launch_db_mysql.sh ${scale}
done
done

