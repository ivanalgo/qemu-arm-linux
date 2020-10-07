#!/bin/bash

./download.sh
docker build -t arm-kernel-3.16-qemu .
