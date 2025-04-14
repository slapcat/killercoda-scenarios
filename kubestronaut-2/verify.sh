#!/bin/bash
if [[ $(kubectl get deploy web -o jsonpath='{.status.readyReplicas}') != 1 ]] ; then
	exit 1
fi
