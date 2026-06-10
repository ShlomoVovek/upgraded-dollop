# Docker & K8s
docker ps # running docker-desktop
kubectl culster-info # showing cluster IP and path
kubectl get nodes # show all nodes in cluster
kubectl get pvc # check PVC status
# postgres
kubectl apply -f postgres.yaml # apply postgres configurations
ubectl exec -it deployment/postgres-deployment -- psql -U admin -d sentiment_db # connect to db & open db

## postgres-terminal
\dt # show exists table
\q # quit terminal

## Airflow 3.X {admin, admin}
kubectl port-forward svc/airflow-api-server 8080:8080 -n airflow # start port forwarding to port 8080, allows open airflow UI