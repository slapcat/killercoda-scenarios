apt install debootstrap qemu-utils
unlink /root/filesystem

cat <<EOF > /root/config.yaml
image:
  distribution: "alpinelinux"
  release: edge

source:
  downloader: alpinelinux
  same_as: 3.12
  url: https://mirrror.csclub.uwaterloo.ca/alpine/
  keys:
  # 0482D84022F52DF1C4E7CD43293ACD0907D9495A

packages:
  manager: apk

actions:
  - trigger: post-files
    action:
      #!/bin/sh

      touch /done

targets:
  lxc:
    create_message: |
      You just created an {{ image.description }} container.

    config:
    - type: all
      before: 5
      content: |-
        lxc.include = LXC_TEMPLATE_CONFIG/alpine.common.conf
    - type: user
      before: 5
      content: |-
        lxc.include = LXC_TEMPLATE_CONFIG/alpine.userns.conf
    - type: all
      after: 4
      content: |-
        lxc.include = LXC_TEMPLATE_CONFIG/common.conf
    - type: user
      after: 4
      content: |-
        lxc.include = LXC_TEMPLATE_CONFIG/userns.conf
    - type: all
      content: |-
        lxc.arch = {{ image.architecture_personality }}
  lxd:
    vm:
      # Size in GiB
      size: 25
      filesystem: ext4

files:
- path: /etc/hostname
  generator: hostname

- path: /etc/hosts
  generator: hosts

- generator: fstab
  types:
  - vm

- path: /etc/default/grub
  generator: dump
  pongo: true
  content: |-
    # Set the recordfail timeout
    GRUB_RECORDFAIL_TIMEOUT=0

    # Do not wait on grub prompt
    GRUB_TIMEOUT=0

    # Set the default commandline
    GRUB_CMDLINE_LINUX_DEFAULT="console=tty1 console=ttyS0 modules=sd-mod,usb-storage,{{ targets.lxd.vm.filesystem }} rootfstype={{ targets.lxd.vm.filesystem }}"

    # Set the grub console type
    GRUB_TERMINAL=console

    # Disable os-prober
    GRUB_DISABLE_OS_PROBER=true
  types:
  - vm

- path: /etc/network/interfaces
  generator: dump
  content: |-
    auto eth0
    iface eth0 inet dhcp
    hostname $(hostname)

- path: /etc/inittab
  generator: dump
  content: |-
    # /etc/inittab
    ::sysinit:/sbin/openrc sysinit
    ::sysinit:/sbin/openrc boot
    ::wait:/sbin/openrc default

    # Set up a couple of getty's
    ::respawn:/sbin/getty 38400 console
    tty1::respawn:/sbin/getty 38400 tty1
    tty2::respawn:/sbin/getty 38400 tty2
    tty3::respawn:/sbin/getty 38400 tty3
    tty4::respawn:/sbin/getty 38400 tty4

    # Stuff to do for the 3-finger salute
    ::ctrlaltdel:/sbin/reboot

    # Stuff to do before rebooting
    ::shutdown:/sbin/openrc shutdown

- path: /hello.sh
  generator: dump
  content:
    #!/bin/bash
    echo 'hello world!'
  variants:
  - cloud

- path: /etc/inittab
  generator: template
  name: inittab
  content: |-
    # /etc/inittab
    ::sysinit:/sbin/openrc sysinit
    ::sysinit:/sbin/openrc boot
    ::wait:/sbin/openrc default

    # Set up a couple of getty's
    ::respawn:/sbin/getty 38400 console

    # Stuff to do for the 3-finger salute
    ::ctrlaltdel:/sbin/reboot

    # Stuff to do before rebooting
    ::shutdown:/sbin/openrc shutdown

- name: meta-data
  generator: cloud-init
  variants:
  - cloud

- name: network-config
  generator: cloud-init
  content: |-
    version: 1
    config:
    - type: physical
      name: eth0
      subnets:
      - type: dhcp
        control: auto
  variants:
  - cloud

- name: user-data
  generator: cloud-init
  variants:
  - cloud

- name: vendor-data
  generator: cloud-init
  variants:
  - cloud
EOF
