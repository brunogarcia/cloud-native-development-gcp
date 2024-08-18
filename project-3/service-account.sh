export FACT_SERVICE_SA=fact-service-sa
export FACT_SERVICE_NAME=facts-service
export PROJECT_ID=$(gcloud config get-value project)

gcloud iam service-accounts create $FACT_SERVICE_SA \
  --display-name "${FACT_SERVICE_NAME} service account"

# Add the Cloud SQL Client role
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:${FACT_SERVICE_SA}@${PROJECT_ID}.iam.gserviceaccount.com \
  --role=roles/cloudsql.client

# Give the service account access to the secret in Secret Manager
gcloud secrets add-iam-policy-binding $FACT_SERVICE_DB_PASSWORD_SECRET_NAME \
  --member=serviceAccount:${FACT_SERVICE_SA}@${PROJECT_ID}.iam.gserviceaccount.com \
  --role=roles/secretmanager.secretAccessor
