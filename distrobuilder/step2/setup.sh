rm -r /root/*
cat <<EOF > /root/step2.yaml
image:
  description: step2
  distribution: ubuntu
  release: jammy
  architecture: x86_64

source:
  downloader: debootstrap
  same_as: gutsy
  url: http://archive.ubuntu.com/ubuntu
  keyserver: keyserver.ubuntu.com
  keys:
  - 0x790BC7277767219C42C86F933B4FE6ACC0B21F32
  - 0xf6ecb3762474eda9d21b7022871920d1991bc93c

files:
  - generator: hostname
    path: /etc/hostname

  - generator: hosts
    path: /etc/hosts

  - generator: remove
    path: /etc/resolv.conf

packages:
  manager: apt

actions:
  - trigger: post-files
    action:
      #!/bin/sh

      touch /done

mappings:
  architecture_map: debian
EOF
