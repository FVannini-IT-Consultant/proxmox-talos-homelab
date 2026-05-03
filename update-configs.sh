#!/bin/bash
KUBECONFIG=~/.kube/config:_out/kubeconfig.yaml kubectl config view --flatten > /tmp/merged.yaml && mv /tmp/merged.yaml ~/.kube/config
talosctl config merge _out/talosconfig.yaml