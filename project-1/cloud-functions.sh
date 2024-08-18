export CLOUD_FUNCTION_NAME=tag-updater
export SERVICE_ACCOUNT_NAME=tag-updater-sa
export REGION=$(gcloud config get functions/region)

# Cloud Functions related commands
gcloud functions list
gcloud functions call $CLOUD_FUNCTION_NAME --gen2 --region=$REGION
gcloud functions logs read $CLOUD_FUNCTION_NAME --gen2 --region=$REGION

# Deploy the Cloud Function
gcloud functions deploy $CLOUD_FUNCTION_NAME \
    --gen2 \
    --runtime=go120 \
    --region=$REGION \
    --trigger-http \
    --no-allow-unauthenticated \
    --env-vars-file env.yaml \
    --source=./cloud-functions/tag-updater \
    --service-account="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" 

# Export the URI of the Cloud Function
export CLOUD_FUNCTION_URI=$(gcloud functions describe $CLOUD_FUNCTION_NAME --gen2 --region=$REGION --format='value(serviceConfig.uri)')

# Call the Cloud Function
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" $CLOUD_FUNCTION_URI