#!/bin/bash
grep -q '"The highest activity a human being can attain is learning for understanding, because to understand is to be free." - Baruch Spinoza' /tmp/carol.flag && \
grep -Eq 'maxlogins.*2' /etc/security/limits.conf && \
stat -c "%U" /tmp/carol.flag | grep -q carol
