#!/bin/bash
# User data script for EKS worker nodes
# Bootstraps the kubelet, joins the cluster, and applies node-group-specific tuning.

set -o xtrace

CLUSTER_NAME="${cluster_name}"
CLUSTER_ENDPOINT="${cluster_endpoint}"
CLUSTER_CA="${cluster_ca}"
BOOTSTRAP_ARGUMENTS="${bootstrap_arguments}"

/etc/eks/bootstrap.sh "$CLUSTER_NAME" \
  --b64-cluster-ca "$CLUSTER_CA" \
  --apiserver-endpoint "$CLUSTER_ENDPOINT" \
  $BOOTSTRAP_ARGUMENTS

echo "EKS worker node bootstrap complete for cluster: $CLUSTER_NAME"
