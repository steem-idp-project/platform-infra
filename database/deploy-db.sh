#!/bin/bash

manifest_dir="database/manifests"

echo
echo "Apply data persistent volume"
kubectl apply -f $manifest_dir/postgres-data-pv.yaml

echo
echo "Apply data persistent volume claim"
kubectl apply -f $manifest_dir/postgres-data-pvc.yaml

echo
echo "Apply init configmap for postgres"
kubectl apply -f $manifest_dir/postgres-init-cfg.yaml

echo
echo "Apply postgres service"
kubectl apply -f $manifest_dir/postgres-svc.yaml

echo
echo "Apply postgres deployment"
kubectl apply -f $manifest_dir/postgres-dep.yaml

echo
echo "Waiting for postgres cluster to be ready"
kubectl wait --for=condition=Available --timeout=300s deployment/postgres
