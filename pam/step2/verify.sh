#!/bin/bash
grep -q '"Education is bitter, but its fruit is sweet." - Aristotle' /tmp/bob.flag && stat -c "%U" /tmp/bob.flag | grep -q bob
