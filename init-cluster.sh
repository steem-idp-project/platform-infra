#!/bin/bash

# Uncomment the following line to set the PATH-TO-REPO in cluster.yaml if you
# want to persist files outside the kind cluster (purely for local development)
# grep "PATH-TO-REPO" cluster.yaml > /dev/null
# if [[ "$?" -ne 1 ]]; then
#     echo "Please set the PATH-TO-REPO in cluster.yaml"
#     exit 1
# fi

pgsql_creds_file="database/manifests/template-postgres-user-creds.yaml"
if [[ -n "$1" ]]; then
    echo "Using provided postgres user creds file: $1"
    pgsql_creds_file="$1"
else
    echo "Using default postgres user creds file: $pgsql_creds_file"
fi

# create the kubernetes with 1 control plane and 2 workers
kind create cluster --config cluster.yaml

kubectl wait --for=condition=Ready nodes --all --timeout=300s

kubectl apply -f $pgsql_creds_file

# deploy and initialize database
./database/deploy-db.sh
./io-api/deploy-io-api.sh
./pgadmin/deploy-pgadmin.sh
./prometheus/deploy-prometheus.sh
./nginx/deploy-nginx.sh
