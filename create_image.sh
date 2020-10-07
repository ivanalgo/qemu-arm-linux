#!/bin/bash

dd if=/dev/zero of=/opt/a9rootfs.ext3 bs=1M count=32
yes | mkfs.ext3 /opt/a9rootfs.ext3
rm -rf /opt/tmp-fs
mkdir /opt/tmp-fs
mount -t ext3 /opt/a9rootfs.ext3 /opt/tmp-fs/ -o loop
cp -r /opt/rootfs/* /opt/tmp-fs
sync
umount /opt/tmp-fs
rm -rf /opt/tmp-fs
