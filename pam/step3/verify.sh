#!/bin/bash
cd /tmp
file /root/disk.qcow2 && tar xf /root/lxd.tar.xz && grep 'inittab' /tmp/metadata.yaml && rm /tmp/metadata.yaml
