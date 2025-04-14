#!/bin/bash

kubectl taint node controlplane Ready=True:NoSchedule
kubectl create deploy web --replicas=1 --image=nginx

touch /tmp/finished
