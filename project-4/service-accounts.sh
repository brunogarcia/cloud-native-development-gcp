export PROFILE_SERVICE_SA=profile-service-sa
export PROFILE_SERVICE_NAME=profile-service
export FACT_CHANGED_SUBSCRIPTION=fact-changed-subscription

export REGION=$(gcloud config get functions/region)
export PROJECT_ID=$(gcloud config get-value project)

gcloud iam service-accounts create ${PROFILE_SERVICE_SA} \
  --display-name "${PROFILE_SERVICE_NAME} service account"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:$PROFILE_SERVICE_SA@$PROJECT_ID.iam.gserviceaccount.com \
  --role=roles/logging.logWriter

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:$PROFILE_SERVICE_SA@$PROJECT_ID.iam.gserviceaccount.com \
  --role=roles/datastore.user

gcloud iam service-accounts create ${FACT_CHANGED_SUBSCRIPTION}-sa \
  --display-name="${FACT_CHANGED_SUBSCRIPTION} service account"