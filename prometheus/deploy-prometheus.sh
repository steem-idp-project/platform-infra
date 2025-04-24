#!/bin/bash

echo ""
echo "Installing Prometheus helm chart"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
    --set grafana.adminUser=$GRAFANA_ADMIN_USER \
    --set grafana.adminPassword=$GRAFANA_ADMIN_PASSWORD \
    --set grafana.persistence.enabled=true
    # --set grafana.grafana.ini.server.root_url=https://idp.admin-steem.com/grafana \
    # --set grafana.grafana.ini.server.domain=idp.admin-steem.com \
    # --set grafana.grafana.ini.server.serve_from_sub_path=true
