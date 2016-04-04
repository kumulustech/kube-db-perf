#!/bin/bash
offset=${1:-0}
for vals in 1 2 4 6 12
do
for scale in ${vals}
do
./launch_db_nvme.sh ${scale}
done
done

