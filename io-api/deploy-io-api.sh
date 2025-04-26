#!/bin/bash

manifest_dir="io-api/manifests"

echo
echo "Deploying io-api"
kubectl apply -f $manifest_dir/io-dep.yaml
kubectl wait --for=condition=available --timeout=300s deployment/io-api

echo
echo "Deploying io-api service"
kubectl apply -f $manifest_dir/io-svc.yaml
