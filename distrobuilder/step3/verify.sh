#!/bin/bash

file /root/disk.qcow2 && tar xf /root/lxd.tar.xz && grep 'virtual-machine' /root/metadata.yaml
