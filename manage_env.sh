# This script is used to manage the environment for the project.
# It can be used to set up the environment, clean up the environment, and run tests.
# It will check the cluster is online, initiate Port-forwarding for both Airflow and Postgres,
# and will open the Airflow UI in the browser.

#!/bin/bash

# coloring
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CLUSTER_NAME="kind"

echo -e "${BLUE}[*] checking if cluster is online...${NC}"

# 1. check if cluster is online
if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
    echo -e "${YELLOW}[!] cluster '$CLUSTER_NAME' is not running. trying to start it...${NC}"

    # try to use configuration file to start the cluster
    if [ -f "kind-config.yaml" ]; then
        kind create cluster --name "$CLUSTER_NAME" --config kind-config.yaml
    else
        kind create cluster --name "$CLUSTER_NAME"
    fi
else
    echo -e "${GREEN}[+] cluster '$CLUSTER_NAME' is online.${NC}"
fi
# 2. post-forwarding for Airflow and Postgres
echo -e "${BLUE}[*] cleaning up previous environment if there are any...${NC}"
killall kubectl 2>/dev/null || true

echo -e "${BLUE}[*] initiating port-forwarding for Airflow and Postgres...${NC}"

# 2.1 post forwarding for postgres
echo -e "${YELLOW}[!] initiating port-forwarding for Postgres to local port 5432...${NC}"
kubectl port-forward svc/postgres-service 5432:5432 > /dev/null 2>&1 &

# 2.2 post forwarding for Airflow
echo -e "${YELLOW}[!] initiating port-forwarding for Airflow to local port 8080...${NC}"
kubectl port-forward svc/airflow-service 8080:8080 -n airflow > /dev/null 2>&1 &

# wait 2 seconds for the port-forwarding to be established
sleep 2

echo -e "${GREEN}[+] Everything is set up!${NC}"
echo -e "${BLUE}[*] Airflow UI:${NC} http://localhost:8080"
echo -e "${BLUE}[*] Postgres:${NC} localhost:5432 (user: admin, password: postgres-secret, database: sentiment_db)"

# for MacOS users, open the Airflow UI in the default browser
open "http://localhost:8080"

echo -e "${GREEN}[+] Do not close this terminal window while using the environment.${NC}"

wait