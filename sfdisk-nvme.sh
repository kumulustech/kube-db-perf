#!/bin/bash
# sfdisk script
sfdisk -Lf /dev/nvme0n1 <<EOF
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

sfdisk -Lf /dev/nvme1n1 <<EOF
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

for n in {5..10}
do
  mkdir /mnt/nvme$[$n-4]
  mkfs.ext4 -L nvme$[$n-4] /dev/nvme0n1p$n
  echo "/dev/nvme0n1p$n /mnt/nvme$[$n-4] ext4 defaults 0 2" >> /etc/fstab
done

for n in {5..10}
do
  mkdir /mnt/nvme$[$n+2]
  mkfs.ext4 -L nvme$[$n+2] /dev/nvme1n1p$n
  echo "/dev/nvme1n1p$n /mnt/nvme$[$n+2] ext4 defaults 0 2" >> /etc/fstab
done
mount -a
