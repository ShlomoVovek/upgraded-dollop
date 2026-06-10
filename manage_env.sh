#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

CLUSTER_NAME="kind"

echo -e "${BLUE}[*] Checking Kubernetes cluster status...${NC}"
if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
    echo -e "${RED}[!] Cluster '$CLUSTER_NAME' not found. Please run the installation script first.${NC}"
    exit 1
fi

echo -e "${BLUE}[*] Cleaning up old port-forwards...${NC}"
killall kubectl 2>/dev/null || true

echo -e "${BLUE}[*] Verifying Airflow webserver service exists...${NC}"
# Check if the service actually exists in the airflow namespace
if ! kubectl get svc airflow-api-server -n airflow >/dev/null 2>&1; then
    echo -e "${RED}[!] Service 'airflow-apiserver' not found in namespace 'airflow'.${NC}"
    echo -e "${YELLOW}[?] Did you run the Helm installation? Run 'kubectl get svc -A' to check names.${NC}"
    exit 1
fi

echo -e "${BLUE}[*] Starting Port-Forwarding...${NC}"

# Forwarding PostgreSQL (Modify service name if different)
if kubectl get svc postgres-service >/dev/null 2>&1; then
    echo -e "${YELLOW}--> Connecting PostgreSQL to local port 5432...${NC}"
    kubectl port-forward svc/postgres-service 5432:5432 > /dev/null &
else
    echo -e "${YELLOW}[!] postgres-service not found in default namespace. Skipping DB forward.${NC}"
fi

# Forwarding Airflow Webserver
echo -e "${YELLOW}--> Connecting Apache Airflow 3 to local port 8080...${NC}"
# Removed '> /dev/null 2>&1' to allow errors to print if it fails
kubectl port-forward svc/airflow-api-server 8080:8080 -n airflow &

sleep 3

echo -e "${GREEN}[V] Setup script finished execution.${NC}"
echo -e "${BLUE}- Airflow UI:${NC} http://localhost:8080"
echo -e "${BLUE}- Username: 'admin'; Password: 'admin'${NC}"

open "http://localhost:8080" || true

wait