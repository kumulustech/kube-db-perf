#!/bin/bash
# sfdisk script

packet-block-storage-attach
iter=0
for n in `ls /dev/mapper/volume-*|cut -d'-' -f2`
do
sfdisk -Lf /dev/mapper-${n} <<EOF
,,E
,,
,,
,,
,127182,L
,127182,L
,127182,L
,127182,L
,127182,L
,,L
EOF

if [[ $iter -eq 0 ]]
then
  incr=-4
else
  incr=2
fi

for m in {5..10}
do
  mkdir /mnt/data$[${n}+${incr}]
  mkfs.ext4 -L data$[${n}+${incr}] /dev/mapper/volume-${n}p${m}
  echo "/dev/mapper/volume-${n}p${m} /mnt/data$[${m}+${incr}] ext4 defaults 0 2" >> /etc/fstab
done
iter=1
done
mount -a
