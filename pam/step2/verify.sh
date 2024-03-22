#!/bin/bash
grep -q '"Education is bitter, but its fruit is sweet." - Aristotle' /tmp/bob.flag && \
! grep -q 'mountpoint="/root/private"' /home/bob/.pam_mount.conf.xml && \
stat -c "%U" /tmp/bob.flag | grep -q bob
