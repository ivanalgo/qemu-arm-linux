#!/bin/bash

qemu-system-arm -M vexpress-a9 -m 512M -kernel /opt/build/linux-3.16/arch/arm/boot/zImage -dtb /opt/build/linux-3.16/arch/arm/boot/dts/vexpress-v2p-ca9.dtb -nographic -append "root=/dev/mmcblk0  console=ttyAMA0" -sd /opt/a9rootfs.ext3
