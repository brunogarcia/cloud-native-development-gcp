export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud config get functions/region)
export SKILL_SERVICE_NAME=skill-service

gcloud run deploy $SKILL_SERVICE_NAME --source . \
  --env-vars-file=.env.yaml \
  --allow-unauthenticated \
  --region=$REGION

# Use the following command to store the URL of the service in an environment variable:
export SKILL_SERVICE_URL=$(gcloud run services describe $SKILL_SERVICE_NAME --region=$REGION --format='value(status.url)')

# You could then open the service
curl -X GET $SKILL_SERVICE_URL/autocomplete?prefix=react

# The following command updates the service account for the Cloud Run service:
export SKILL_SERVICE_SA=skill-service-sa

gcloud run services update $SKILL_SERVICE_NAME \
  --region=$REGION \
  --service-account $SKILL_SERVICE_SA@$PROJECT_ID.iam.gserviceaccount.com
