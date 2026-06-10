#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

CLUSTER_NAME="kind"

echo "=== 1. Cleaning up old cluster environments ==="
kind delete cluster --name "$CLUSTER_NAME" || true

echo "=== 2. Creating a fresh Kubernetes cluster ==="
kind create cluster --name "$CLUSTER_NAME"

echo "=== 3. Deploying PostgreSQL with HN Schema ==="
# Apply the ConfigMap, Deployment, and Service defined in step 1
kubectl apply -f ./infrastructure/postgres-setup.yaml

echo "=== 4. Setting up Apache Airflow 3 Chart ==="
# Add and update helm repositories
helm repo add apache-airflow https://airflow.apache.org
helm repo update

echo "=== 5. Installing Apache Airflow 3 inside 'airflow' namespace ==="
# Create namespace and install Airflow 3 components
kubectl create namespace airflow || true
helm upgrade --install airflow apache-airflow/airflow \
  --namespace airflow \
  --set defaultAirflowRepository=apache/airflow \
  --set defaultAirflowTag=3.0.0 \
  --set webserver.service.type=ClusterIP \
  --timeout 11m

echo "=== 6. Infrastructure Deployment Initiated ==="
echo "Pods are now spinning up inside Docker. Use 'kubectl get pods -A' to monitor status."