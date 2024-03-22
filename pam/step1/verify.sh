#!/bin/bash
grep -q '"The only true wisdom is in knowing you know nothing." - Socrates' /tmp/alice.flag && \
grep -q 'success=2' /etc/pam.d/common-auth && \
stat -c "%U" /tmp/alice.flag | grep -q alice
