#!/bin/bash

[ ! -d source ] || mkdir -p source
cd source 
wget -c https://mirrors.edge.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.gz
wget -c http://wiki.qemu-project.org/download/qemu-2.0.2.tar.bz2
wget -c http://www.busybox.net/downloads/busybox-1.32.0.tar.bz2 
