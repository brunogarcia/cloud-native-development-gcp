gcloud services enable secretmanager.googleapis.com

export FACT_SERVICE_DB_PASSWORD_SECRET_NAME=fact_service_db_password_secret

gcloud secrets create $FACT_SERVICE_DB_PASSWORD_SECRET_NAME \
    --replication-policy=automatic \
    --data-file=<(echo -n $FACT_SERVICE_DB_PASSWORD)