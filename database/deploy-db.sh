#!/bin/bash

manifest_dir="database/manifests"

echo
echo "Installing postgres cloudnative operator"
helm repo add cloudnative-pg https://cloudnative-pg.io/charts
helm repo update

echo
echo "Installing postgres operator"
helm upgrade --install cnpg \
    --namespace cnpg-system \
    --create-namespace \
    cloudnative-pg/cloudnative-pg

echo
echo "Waiting for postgres operator to be ready"
kubectl wait --for=condition=Available --timeout=300s deployment/cnpg-cloudnative-pg -n cnpg-system

echo
echo "Apply init configmap for postgres"
kubectl apply -f $manifest_dir/postgres-init-cfg.yaml

echo
echo "Apply postgres cluster"
kubectl apply -f $manifest_dir/postgres-cluster.yaml

echo
echo "Waiting for postgres cluster to be ready"
kubectl wait --for=condition=Ready --timeout=300s cluster/postgres

