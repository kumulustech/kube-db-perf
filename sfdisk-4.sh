#!/bin/bash
set -x
for n in 0 1 2 3
do
sfdisk -Lf /dev/nvme${n}n1 <<EOF
,,E
,,
,,
,,
,190770,L
,190770,L
,190770,L
,,L
EOF
done
