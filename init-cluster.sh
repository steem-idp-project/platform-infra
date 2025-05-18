#!/bin/bash

# Uncomment the following line to set the PATH-TO-REPO in cluster.yaml if you
# want to persist files outside the kind cluster (purely for local development)
# grep "PATH-TO-REPO" cluster.yaml > /dev/null
# if [[ "$?" -ne 1 ]]; then
#     echo "Please set the PATH-TO-REPO in cluster.yaml"
#     exit 1
# fi

check_fail() {
    if [[ "$?" -ne 0 ]]; then
        echo "Error: $1"
        exit 1
    fi
}

pgsql_creds_file="database/manifests/template-postgres-user-creds.yaml"
if [[ -n "$1" ]]; then
    echo "Using provided postgres user creds file: $1"
    pgsql_creds_file="$1"
else
    echo "Using default postgres user creds file: $pgsql_creds_file"
fi

secret_file="auth-api/manifests/template-auth-secrets.yaml"
if [[ -n "$1" ]]; then
    echo "Using provided auth-api secrets file: $1"
    pgsql_creds_file="$1"
else
    echo "Using default auth-api secrets file: $secret_file"
fi

# create the kubernetes with 1 control plane and 2 workers
kind create cluster --config cluster.yaml

kubectl wait --for=condition=Ready nodes --all --timeout=300s

kubectl apply -f $pgsql_creds_file
kubectl apply -f $secret_file

# deploy and initialize database
./database/deploy-db.sh
check_fail "Failed to deploy database"

./io-api/deploy-io-api.sh
check_fail "Failed to deploy io-api"

./auth-api/deploy-auth-api.sh
check_fail "Failed to deploy auth-api"

./steem-api/deploy-steem-api.sh
check_fail "Failed to deploy steem-api"

./pgadmin/deploy-pgadmin.sh
check_fail "Failed to deploy pgadmin"

./prometheus/deploy-prometheus.sh
check_fail "Failed to deploy prometheus"

./portainer/deploy-portainer.sh
check_fail "Failed to deploy portainer"

./nginx/deploy-nginx.sh
check_fail "Failed to deploy nginx"

./actions-runner/deploy-actions-runner.sh
check_fail "Failed to deploy actions-runner"
