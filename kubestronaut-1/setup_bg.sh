#!/bin/bash
sed -i 's/- kube-apiserver$/- kube-apiserver\n    - --a-fake-flag-to-break-apiserver/' /etc/kubernetes/manifests/kube-apiserver.yaml
mv /etc/kubernetes/manifests/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yamlll
touch /tmp/finished
