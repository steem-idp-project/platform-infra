#!/bin/bash

echo ""
echo "Installing Prometheus helm chart"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
    -f prometheus/values.yaml \
    --set grafana.adminUser=$GRAFANA_ADMIN_USER \
    --set grafana.adminPassword=$GRAFANA_ADMIN_PASSWORD \
    --set grafana.persistence.enabled=true

kube 
