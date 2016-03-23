#!/bin/bash
offset=${2:-2}
mongo 10.0.0.$[$1*3+20+${offset}] <<EOF
rs.initiate()
EOF
