#!/bin/bash

file /root/rootfs.squashfs && tar xf /root/lxd.tar.xz && grep 'Alpine' /root/metadata.yaml
