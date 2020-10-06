FROM ubuntu:14.04
MAINTAINER Yongting Lin <linyongting@gmail.com>

RUN apt-get update -y && \
    apt-get install -y gcc-arm-linux-gnueabi apt-utils wget make gcc bc zlib1g-dev \
                       libglib2.0-dev autoconf python g++ pkg-config zlib1g-dev \
                       libtool bison flex

COPY source /opt/build
RUN cd /opt/build/ &&  \
    tar zxf linux-4.9.tar.gz && \
    cd linux-4.9 && \
    make CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm vexpress_defconfig && \
    make CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm -j

RUN cd /opt/build/ && \
    tar -xjf qemu-2.0.2.tar.bz2 && \
    cd qemu-2.0.2 && \
    ./configure --target-list=arm-softmmu --audio-drv-list= && \
    make -j && \
    make install

RUN cd /opt/build/ && \
    tar -xjf busybox-1.32.0.tar.bz2 && \
    cd busybox-1.32.0 && \
    make defconfig && \
    make CROSS_COMPILE=arm-linux-gnueabi- -j && \
    make install CROSS_COMPILE=arm-linux-gnueabi- 

RUN mkdir -p /opt/rootfs/dev && \
    mkdir -p /opt/rootfs/etc/init.d && \
    mkdir -p /opt/rootfs/lib && \
    cp /opt/build/busybox-1.32.0/_install/* -r /opt/rootfs/ && \
    cp -P /usr/arm-linux-gnueabi/lib/* /opt/rootfs/lib/

RUN mknod /opt/rootfs/dev/tty1 c 4 1 && \
    mknod /opt/rootfs/dev/tty2 c 4 2 && \
    mknod /opt/rootfs/dev/tty3 c 4 3 && \
    mknod /opt/rootfs/dev/tty4 c 4 4

#RUN cp -r /opt/rootfs/* /opt/vol/tmp-fs/ && sync && cp /opt/vol/9rootfs.ext3 /opt/9rootfs.ext3
