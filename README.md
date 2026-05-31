# upgraded-dollop
Targeting Hi-Tech industry employment trends

## Epic 1. Local infra
1.1 created new repo, gitignore, project board
1.2 create new K8s Cluster with KIND
1.3 Deploy PostgreSQL as a replacemnet to BigQuery for raw data storage (Bronze).
    We set PersistentVolumeClaim (PVC) for keeping data persistent if pods is getting reset.
1.4 Created Basic DB Scheme for bronze and gold layers

## Epic 2. Data Ingestion pipeline with Airflow
2.1 created new namespace for airflow in K8s