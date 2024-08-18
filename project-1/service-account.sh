export CLOUD_FUNCTION_NAME=tag-updater
export SERVICE_ACCOUNT_NAME=tag-updater-sa
export REGION=$(gcloud config get functions/region)
export PROJECT_ID=$(gcloud config get project)
export BUCKET_NAME="${PROJECT_ID}-skillsmapper-tags"

gcloud iam service-accounts list

gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name "${CLOUD_FUNCTION_NAME} service account"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
  --role=roles/bigquery.jobUser

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com:objectAdmin gs://$BUCKET_NAME

# Service account on the Cloud Scheduler job

export INVOKER_SERVICE_ACCOUNT_NAME=tag-updater-invoker-sa

gcloud iam service-accounts create $INVOKER_SERVICE_ACCOUNT_NAME \
	--display-name "${CLOUD_FUNCTION_NAME} invoker service account"

gcloud run services add-iam-policy-binding $CLOUD_FUNCTION_NAME \
  --region=$REGION \
  --member=serviceAccount:$INVOKER_SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
  --role='roles/run.invoker'


