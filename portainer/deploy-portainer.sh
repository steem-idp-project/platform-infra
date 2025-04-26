#!/bin/bash

# For some reason, Portainer refuses to work when exposed as a subpath on a
# Nginx virtual server CRD, so for now we are exposing it with a standard Ingress
echo ""
echo "Installing Portainer helm chart"
helm repo add portainer https://portainer.github.io/k8s/
helm repo update
helm upgrade --install --create-namespace -n portainer portainer portainer/portainer \
    --set service.type=ClusterIP \
    --set tls.force=false \
    --set image.tag=lts \
    --set ingress.enabled=true \
    --set ingress.ingressClassName=nginx \
    --set ingress.hosts[0].host=idp.portainer.com \
    --set ingress.hosts[0].paths[0].path="/"
kubectl wait --for=condition=available --timeout=300s -n portainer deployment/portainer
