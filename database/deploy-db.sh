#!/bin/bash

# nfs_ip=$(kubectl get service nfs -o json | jq -r ".spec.clusterIP")
# nfs_share=$(kubectl get deployments.apps nfs -o json | jq -r '.spec.template.spec.containers | .[0].volumeMounts | .[0].mountPath')

# helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/ 2> /dev/null
# helm install nfs-client nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
#     --set nfs.server=$nfs_ip \
#     --set nfs.path=/ \
#     --values nfs/manifests/nfs-client-values.yaml

manifest_dir="database/manifests"

echo
echo "Apply data persistent volume"
kubectl apply -f $manifest_dir/postgres-data-pv.yaml

echo
echo "Apply data persistent volume claim"
kubectl apply -f $manifest_dir/postgres-data-pvc.yaml

echo
echo "Apply postgres service"
kubectl apply -f $manifest_dir/postgres-svc.yaml

echo
echo "Apply postgres deployment"
kubectl apply -f $manifest_dir/postgres-dep.yaml

echo
echo "Waiting for postgres cluster to be ready"
kubectl wait --for=condition=Available --timeout=300s deployment/postgres
