#!/bin/bash

manifest_dir="auth-api/manifests"

echo
echo "Deploying autho-api"
kubectl apply -f $manifest_dir/auth-dep.yaml
kubectl wait --for=condition=available --timeout=300s deployment/auth-api

echo
echo "Deploying auth-api service"
kubectl apply -f $manifest_dir/auth-svc.yaml
