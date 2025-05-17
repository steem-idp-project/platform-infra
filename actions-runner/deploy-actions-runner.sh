#!/bin/bash

NAMESPACE="arc-systems"
GITHUB_CONFIG_URL="https://github.com/steem-idp-project"

if [ -z "$RUNNER_TOKEN" ]; then
    echo "RUNNER_TOKEN for Actions Runner is not set. Please set it before running this script."
    exit 1
fi

echo
echo "Deploying GitHub Actions Runner Controller"
helm upgrade --install arc \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller

echo
echo "Deploying GitHub Actions Runner"
helm upgrade --install "steem-runner" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="${RUNNER_TOKEN}" \
    --set containerMode.type=dind oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set

echo
echo "Creating GitHub Actions Runner Role "
kubectl create role --verb=patch --resource=deployments.apps updater-role

echo
echo "Creating GitHub Actions Runner Service Account"
kubectl create serviceaccount runner-updater-sa

echo
echo "Binding GitHub Actions Runner Service Account to Role"
kubectl create rolebinding runner-updater-sa-binding \
    --role=updater-role \
    --serviceaccount=default:runner-updater-sa

echo
echo "Generating Github Actions Runner Service Account Token (TO BE ADDED TO GITHUB AS SECRET)"
kubectl create token runner-updater-sa --duration=24h
