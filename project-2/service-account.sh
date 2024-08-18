export SKILL_SERVICE_NAME=skill-service
export SKILL_SERVICE_SA=skill-service-sa
export PROJECT_ID=$(gcloud config get project)
export BUCKET_NAME="${PROJECT_ID}-skillsmapper-tags"

gcloud iam service-accounts create ${SKILL_SERVICE_SA} \
 --display-name "${SKILL_SERVICE_NAME} service account"

gsutil iam ch serviceAccount:$SKILL_SERVICE_SA@$PROJECT_ID.iam.gserviceaccount.com:objectViewer gs://$BUCKET_NAME

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:$SKILL_SERVICE_SA@$PROJECT_ID.iam.gserviceaccount.com \
  --role=roles/logging.logWriter

