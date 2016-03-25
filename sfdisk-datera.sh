#!/bin/bash
# sfdisk script

num_vol=`packet-block-storage-attach | wc -l`

for m in {0..$[${num_vol}-1]}
do
  mdm-${m}kdir /mnt/nvme$[${m}+1]
  mkfs.ext4 -L dm-$m /dev/dm-$m
  mount -o _netdev /dev/dm-$m /mnt/nvme$[${m}+1]
done
