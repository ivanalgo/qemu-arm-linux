# qemu-arm-linux

This is a chinese README, sorry for that~

# 动机

我在2015年编写博文《[从零使用qemu模拟器搭建arm运行环境](https://blog.csdn.net/linyt/article/details/42504975)》介绍在 Ubuntu 14.04系统如何一步步构造arm+qemu的运行环境。该文的主要问题是读者有运行环境不一定是Ubuntu 14.04，会遇到不少的软件包安装和编译错误问题，我也没有办法构造复现。从另一方面，我个人再去构造这个环境时，也会遇到类似的问题需要处理，特别是换成Centos发行版之后，处理起来更复杂。

既然每位朋友的发行版都不一样，那可以使用Docker统一构建环境，这是本项目的主要动机，使用Docker基于Ubuntu14.04镜像，再安装相应的软件包，一步步构建整个Linux kernel, busybox软件包，这样可以屏蔽构建环境的差异，同时也可以使用Dockerfile将整个过程自动化。

所以本项目利用容器技术，标准化构造环境，自动化构建整个过程，最后在容器内运行qemu+arm kernel。

# 下载本项目

git clone https://github.com/ivanalgo/qemu-arm-linux.git

# 安装Docker工具

请参考Docker官方文档安装Docker软件：https://docs.docker.com/engine/install/

# 构建Docker镜像

直接运行下面命令:

```
cd qemu-arm-linux

./build-docker-image.sh
```

构建成功后，请使用docker images来检查是否生成 arm-kernel-3.16-qemu 镜像

比如：
```
[root@iZuf6gi6u0x419pu22gquvZ ~]# docker images
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
arm-kernel-3.16-qemu   latest              db5c6750bbe4        About an hour ago   2.29GB
ubuntu                 14.04               df043b4f0cf1        2 weeks ago         197MB
```

# 创建一个特权容器，运行qemu+arm

直接运行下面命令:
docker run -it --privileged  arm-kernel-3.16-qemu /bin/bash

```
[root@iZuf6gi6u0x419pu22gquvZ ~]# docker run -it --privileged  arm-kernel-3.16-qemu /bin/bash
root@bf121ecd02bd:/#
```

# 在容器内创建一个ext3磁盘文件

在上面的容器里运行：/opt/create_image.sh 直创建给qemu使用磁盘，里面包含qemu+arm系统需要的rootfs，过程如下所示：

```
root@bf121ecd02bd:/# /opt/create_image.sh 
32+0 records in
32+0 records out
33554432 bytes (34 MB) copied, 0.0122017 s, 2.7 GB/s
mke2fs 1.42.9 (4-Feb-2014)
/opt/a9rootfs.ext3 is not a block special device.
Proceed anyway? (y,n) Discarding device blocks: done                            
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
8192 inodes, 32768 blocks
1638 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=33554432
4 block groups
8192 blocks per group, 8192 fragments per group
2048 inodes per group
Superblock backups stored on blocks: 
	8193, 24577

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
`

# 在容器内运行qemu+arm kernel

在上面的容器里运行：/opt/start_qemu.sh 运行启动一个qemu+arm系统，直接进入命令对arm linux进行命令操作，过程如下：
`
root@bf121ecd02bd:/# /opt/start_qemu.sh 
Booting Linux on physical CPU 0x0
Initializing cgroup subsys cpuset
Linux version 3.16.0 (root@65f68ac08fad) (gcc version 4.7.3 (Ubuntu/Linaro 4.7.3-12ubuntu1) ) #1 SMP Wed Oct 7 10:26:41 UTC 2020
CPU: ARMv7 Processor [410fc090] revision 0 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine model: V2P-CA9
Memory policy: Data cache writeback
CPU: All CPU(s) started in SVC mode.
PERCPU: Embedded 7 pages/cpu @9fbcf000 s7552 r8192 d12928 u32768
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
Kernel command line: root=/dev/mmcblk0  console=ttyAMA0
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 513116K/524288K available (4563K kernel code, 190K rwdata, 1288K rodata, 247K init, 150K bss, 11172K reserved)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xa0800000 - 0xff000000   (1512 MB)
    lowmem  : 0x80000000 - 0xa0000000   ( 512 MB)
    modules : 0x7f000000 - 0x80000000   (  16 MB)
      .text : 0x80008000 - 0x805bf0a0   (5853 kB)
      .init : 0x805c0000 - 0x805fdd80   ( 248 kB)
      .data : 0x805fe000 - 0x8062dac0   ( 191 kB)
       .bss : 0x8062dac8 - 0x806532e8   ( 151 kB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
NR_IRQS:16 nr_irqs:16 16
GIC CPU mask not found - kernel will fail to boot.
GIC CPU mask not found - kernel will fail to boot.
L2C: platform modifies aux control register: 0x02020000 -> 0x02420000
L2C: device tree omits to specify unified cache
L2C: DT/platform modifies aux control register: 0x02020000 -> 0x02420000
L2C-310 enabling early BRESP for Cortex-A9
L2C-310 full line of zeros enabled for Cortex-A9
L2C-310 dynamic clock gating disabled, standby mode disabled
L2C-310 cache controller enabled, 8 ways, 128 kB
L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x46420001
sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956969942ns
Console: colour dummy device 80x30
Calibrating delay loop... 895.79 BogoMIPS (lpj=4478976)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
CPU: Testing write buffer coherency: ok
CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Setting up static identity map for 0x60454520 - 0x60454578
CPU1: failed to boot: -38
CPU2: failed to boot: -38
CPU3: failed to boot: -38
Brought up 1 CPUs
SMP: Total of 1 processors activated.
CPU: All CPU(s) started in SVC mode.
devtmpfs: initialized
VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 0
regulator-dummy: no parameters
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
cpuidle: using governor ladder
cpuidle: using governor menu
of_amba_device_create(): amba_device_add() failed (-19) for /memory-controller@100e0000
of_amba_device_create(): amba_device_add() failed (-19) for /memory-controller@100e1000
of_amba_device_create(): amba_device_add() failed (-19) for /watchdog@100e5000
of_amba_device_create(): amba_device_add() failed (-19) for /smb/motherboard/iofpga@7,00000000/sysctl@01000
of_amba_device_create(): amba_device_add() failed (-19) for /smb/motherboard/iofpga@7,00000000/wdt@0f000
hw-breakpoint: debug architecture 0x0 unsupported.
Serial: AMBA PL011 UART driver
10009000.uart: ttyAMA0 at MMIO 0x10009000 (irq = 37, base_baud = 0) is a PL011 rev1
console [ttyAMA0] enabled
1000a000.uart: ttyAMA1 at MMIO 0x1000a000 (irq = 38, base_baud = 0) is a PL011 rev1
1000b000.uart: ttyAMA2 at MMIO 0x1000b000 (irq = 39, base_baud = 0) is a PL011 rev1
1000c000.uart: ttyAMA3 at MMIO 0x1000c000 (irq = 40, base_baud = 0) is a PL011 rev1
3V3: 3300 mV 
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Initialized.
Switched to clocksource arm,sp804
NET: Registered protocol family 2
TCP established hash table entries: 4096 (order: 2, 16384 bytes)
TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP: reno registered
UDP hash table entries: 256 (order: 1, 8192 bytes)
UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 1 counters available
futex hash table entries: 1024 (order: 4, 65536 bytes)
squashfs: version 4.0 (2009/01/31) Phillip Lougher
jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
9p: Installing v9fs 9p2000 file system support
msgmni has been set to 1002
io scheduler noop registered (default)
clcd-pl11x: probe of 10020000.clcd failed with error -22
clcd-pl11x: probe of 1001f000.clcd failed with error -22
VD10: at 1000 mV 
VD10_S2: at 1000 mV 
VD10_S3: at 1000 mV 
VCC1V8: at 1800 mV 
DDR2VTT: at 900 mV 
VCC3V3: at 3300 mV 
VIO: at 3300 mV 
40000000.flash: Found 2 x16 devices at 0x0 in 32-bit bank. Manufacturer ID 0x000000 Chip ID 0x000000
NOR chip too large to fit in mapping. Attempting to cope...
Intel/Sharp Extended Query Table at 0x0031
Using buffer write method
Reducing visibility of 131072KiB chip to 65536KiB
40000000.flash: Found 2 x16 devices at 0x0 in 32-bit bank. Manufacturer ID 0x000000 Chip ID 0x000000
NOR chip too large to fit in mapping. Attempting to cope...
Intel/Sharp Extended Query Table at 0x0031
Using buffer write method
Reducing visibility of 131072KiB chip to 65536KiB
Concatenating MTD devices:
(0): "40000000.flash"
(1): "40000000.flash"
into device "40000000.flash"
libphy: smsc911x-mdio: probed
smsc911x 4e000000.ethernet eth0: attached PHY driver [Generic PHY] (mii_bus:phy_addr=4e000000.etherne:01, irq=-1)
smsc911x 4e000000.ethernet eth0: MAC Address: 52:54:00:12:34:56
nxp-isp1760 4f000000.usb: NXP ISP1760 USB Host Controller
nxp-isp1760 4f000000.usb: new USB bus registered, assigned bus number 1
nxp-isp1760 4f000000.usb: Scratch test failed.
nxp-isp1760 4f000000.usb: can't setup: -19
nxp-isp1760 4f000000.usb: USB bus 1 deregistered
usbcore: registered new interface driver usb-storage
mousedev: PS/2 mouse device common for all mice
rtc-pl031 10017000.rtc: rtc core: registered pl031 as rtc0
mmci-pl18x 10005000.mmci: Got CD GPIO #244.
mmci-pl18x 10005000.mmci: Got WP GPIO #245.
mmci-pl18x 10005000.mmci: No vqmmc regulator found
mmci-pl18x 10005000.mmci: mmc0: PL181 manf 41 rev0 at 0x10005000 irq 41,42 (pio)
ledtrig-cpu: registered to indicate activity on CPUs
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
mmc0: new SD card at address 4567
mmcblk0: mmc0:4567 QEMU! 32.0 MiB 
 mmcblk0: unknown partition table
aaci-pl041 10004000.aaci: ARM AC'97 Interface PL041 rev0 at 0x10004000, irq 43
aaci-pl041 10004000.aaci: FIFO 512 entries
oprofile: using arm/armv7-ca9
TCP: cubic registered
NET: Registered protocol family 17
9pnet: Installing 9P2000 support
rtc-pl031 10017000.rtc: setting system clock to 2020-10-07 11:47:19 UTC (1602071239)
ALSA device list:
  #0: ARM AC'97 Interface PL041 rev0 at 0x10004000, irq 43
input: AT Raw Set 2 keyboard as /devices/smb/smb:motherboard/smb:motherboard:iofpga@7,00000000/10006000.kmi/serio0/input/input0
input: ImExPS/2 Generic Explorer Mouse as /devices/smb/smb:motherboard/smb:motherboard:iofpga@7,00000000/10007000.kmi/serio1/input/input2
kjournald starting.  Commit interval 5 seconds
EXT3-fs (mmcblk0): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 179:0.
Freeing unused kernel memory: 244K (805c0000 - 805fd000)
random: nonblocking pool is initialized

Please press Enter to activate this console.  
/ # ls
bin         etc         linuxrc     proc        usr
dev         lib         lost+found  sbin
```

# 欢迎您的贡献
可以直接提issue，也可以发起request，同时也要以发起RP。
