#!/bin/bash
grep -q '"Life is not a problem to be solved, but a reality to be experienced." - Soren Kierkegeaard' /tmp/diego.flag && \
ls -l /var/run/faillock | grep -q 'total 0'  && \
stat -c "%U" /tmp/diego.flag | grep -q diego
