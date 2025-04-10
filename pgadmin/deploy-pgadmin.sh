#!/bin/bash

manifest_dir="pgadmin/manifests"

echo
echo "Apply pgadmin persistent volume"
kubectl apply -f $manifest_dir/pgadmin-data-pv.yaml

echo
echo "Apply pgadmin persistent volume claim"
kubectl apply -f $manifest_dir/pgadmin-data-pvc.yaml

echo
echo "Apply pgadmin configmap"
kubectl apply -f $manifest_dir/pgadmin-env-cfg.yaml

echo
echo "Apply pgadmin servers configmap"
kubectl apply -f $manifest_dir/pgadmin-servers-cfg.yaml

echo
echo "Apply pgadmin service"
kubectl apply -f $manifest_dir/pgadmin-svc.yaml

echo
echo "Apply pgadmin deployment"
kubectl apply -f $manifest_dir/pgadmin-dep.yaml

echo
echo "Waiting for pgadmin cluster to be ready"
kubectl wait --for=condition=Available --timeout=300s deployment/pgadmin
