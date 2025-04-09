#!/bin/bash

grep "PATH-TO-REPO" cluster.yaml > /dev/null
if [[ "$?" -ne 1 ]]; then
    echo "Please set the PATH-TO-REPO in cluster.yaml"
    exit 1
fi

# create the kubernetes with 1 control plane and 2 workers
kind create cluster --config cluster.yaml

kubectl wait --for=condition=Ready nodes --all --timeout=300s

# deploy and initialize database
./database/deploy-db.sh

