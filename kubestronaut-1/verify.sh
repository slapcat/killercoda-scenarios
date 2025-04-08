#!/bin/bash
if ! kubectl get nodes ; then
	exit 1
fi
