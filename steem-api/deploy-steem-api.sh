#!/bin/bash

manifest_dir="steem-api/manifests"

echo
echo "Deploying steem-api"
kubectl apply -f $manifest_dir/steem-dep.yaml
kubectl wait --for=condition=available --timeout=300s deployment/steem-api

echo
echo "Deploying steem-api service"
kubectl apply -f $manifest_dir/steem-svc.yaml
