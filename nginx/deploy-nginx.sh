#!/bin/bash

echo
echo "Install Nginx Ingress Controller"
helm repo add nginx https://helm.nginx.com/stable
helm install steem nginx/nginx-ingress --version 2.1.0 -n nginx-ingress --create-namespace
kubectl wait --for=condition=available --timeout=300s deployment/steem-nginx-ingress-controller -n nginx-ingress

echo
echo "Creating admin-steem tls secret"
kubectl create secret tls admin-tls-certs \
    --cert=nginx/manifests/admin-certs/admin.crt \
    --key=nginx/manifests/admin-certs/admin.key

echo
echo "Creating Nginx virtual server for idp.admin-steem.com"
kubectl apply -f nginx/manifests/virtual-server-admin.yaml

echo
echo "Creating Nginx virtual server route for idp.admin-steem.com/grafana"
kubectl apply -f nginx/manifests/virtual-server-route-grafana.yaml

echo
echo "Creating steem tls secret"
kubectl create secret tls steem-tls-certs \
    --cert=nginx/manifests/steem-certs/steem.crt \
    --key=nginx/manifests/steem-certs/steem.key

echo
echo "Creating Nginx virtual server for idp.steem.com"
kubectl apply -f nginx/manifests/virtual-server-steem.yaml

echo
echo "In order to resolve idp.admin-steem.com and idp.steem.com, the external IP of the Nginx ingress controller must be added to the /etc/hosts file."
echo "Checking if Cloud Provider Kind if running for external IP allocation"
ps aux | grep cloud-provider-kind | grep -v grep | grep -v systemd > /dev/null
if [[ "$?" -ne 0 ]]; then
    echo "Cloud Provider Kind not found. After starting it, you can get the external IP IP with:"
    echo "kubectl get svc -n nginx-ingress -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}'"
    exit 1
else
    echo "Cloud Provider Kind is running. External IP is:"
    echo $(kubectl get svc -n nginx-ingress -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
fi
