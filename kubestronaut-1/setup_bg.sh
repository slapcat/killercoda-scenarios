#!/bin/bash
sed -e 's/- kube-apiserver$/- kube-apiserver\n    - --a-fake-flag-to-break-apiserver/' /etc/kubernetes/manifests/kube-apiserver.yaml
mv /etc/kubernetes/manifests/kube-apiserver.yaml{,l}
touch /tmp/finished
