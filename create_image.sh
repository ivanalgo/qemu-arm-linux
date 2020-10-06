#!/bin/bash

dd if=/dev/zero of=./a9rootfs.ext3 bs=1M count=32
yes | mkfs.ext3 ./a9rootfs.ext3 
rm -rf ./tmp-fs
mkdir ./tmp-fs
chmod a+w ./tmp-fs
mount -t ext3 ./a9rootfs.ext3 ./tmp-fs/ -o loop
