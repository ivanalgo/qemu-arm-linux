# qemu-arm-linux

This is a chinese README, sorry for that~

# 动机

我在2015年编写博文《从零使用qemu模拟器搭建arm运行环境[https://blog.csdn.net/linyt/article/details/42504975]》介绍在 Ubuntu 14.04系统如何一步步构造arm+qemu的运行环境。该文的主要问题是读者有运行环境不一定是Ubuntu 14.04，会遇到不少的软件包安装和编译错误问题，我也没有办法构造复现。从另一方面，我个人再去构造这个环境时，也会遇到类似的问题需要处理，特别是换成Centos发行版之后，处理起来更复杂。

既然每位朋友的发行版都不一样，那可以使用Docker统一构建环境，这是本项目的主要动机，使用Docker基于Ubuntu14.04镜像，再安装相应的软件包，一步步构建整个Linux kernel, busybox软件包，这样可以屏蔽构建环境的差异，同时也可以使用Dockerfile将整个过程自动化。

所以本项目利用容器技术，标准化构造环境，自动化构建整个过程，最后在容器内运行qemu+arm kernel。

# 下载本项目

git clone https://github.com/ivanalgo/qemu-arm-linux.git

# 安装Docker工具

请参考Docker官方文档安装Docker软件：https://docs.docker.com/engine/install/

# 构建Docker镜像

直接运行下面命令:

`
cd qemu-arm-linux
./build-docker-image.sh
`

构建成功后，请使用docker images来检查是否生成 arm-kernel-3.16-qemu 镜像

# 创建一个特权容器，运行qemu+arm

直接运行下面命令:
docker run -it --privileged  arm-kernel-3.16-qemu /bin/bash

# 在容器内创建一个ext3磁盘文件

在上面的容器里运行：/opt/create_image.sh 直创建给qemu使用磁盘，里面包含qemu+arm系统需要的rootfs。

# 在容器内运行qemu+arm kernel

在上面的容器里运行：/opt/start_qemu.sh 运行启动一个qemu+arm系统，直接进入命令对arm linux进行命令操作

# 欢迎您的贡献
可以直接提issue，也可以发起request，同时也要以发起RP。
