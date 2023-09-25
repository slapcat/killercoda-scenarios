#!/bin/bash

file /root/disk.qcow2 && tar xf /root/lxd.tar.xz && grep 'inittab' /root/metadata.yaml
