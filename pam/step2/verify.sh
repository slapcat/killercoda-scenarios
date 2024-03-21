#!/bin/bash
cd /tmp
file /root/rootfs.squashfs && tar xf /root/lxd.tar.xz && grep 'variant: cloud' /tmp/metadata.yaml && rm /tmp/metadata.yaml
