#!/bin/bash

#./create_image.sh
./download.sh
#docker build -t arm-kernel-qemu -v `pwd`/source:/opt/source -v `pwd`/a9rootfs.ext3:/opt/vol/a9rootfs.ext3 -v `pwd`/tmp-fs:/opt/vol/tmp-fs:rw .
docker build -t arm-kernel-qemu -v `pwd`/source:/opt/source .
