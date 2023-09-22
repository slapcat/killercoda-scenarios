#!/bin/bash

file /root/rootfs.squashfs && tar xf /root/lxd.tar.xz && grep 'step1' /root/metadata.yaml
