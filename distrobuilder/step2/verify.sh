#!/bin/bash

file /root/rootfs.squashfs && tar xf /root/lxd.tar.xz && grep 'variant: cloud' /root/metadata.yaml && rm /root/metadata.yaml
