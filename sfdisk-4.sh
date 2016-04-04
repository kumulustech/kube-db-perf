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

i=1
for n in 1 2 3
do
  for m in 5 6 7
  do
    mkfs.ext4 /dev/nvme${n}n1p${m}
    mount /dev/nvme${n}n1p${m} /mnt/nvme$i
    i=$[$i+1]
  done
done

