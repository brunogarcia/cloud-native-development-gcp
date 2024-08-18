export JOB_NAME=tag-updater-job
export CLOUD_FUNCTION_NAME=tag-updater
export SERVICE_ACCOUNT_NAME=tag-updater-sa
export REGION=$(gcloud config get functions/region)

# Enable the required services
gcloud services enable cloudscheduler.googleapis.com

# Create a Cloud Scheduler job that triggers the Cloud Function every Sunday at midnight
gcloud scheduler jobs create http ${JOB_NAME} \
--schedule="0 0 * * SUN" \
--uri=${CLOUD_FUNCTION_URI} \
--max-retry-attempts=3 \
--location=${REGION} \
--oidc-service-account-email="${INVOKER_SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
--oidc-token-audience="${CLOUD_FUNCTION_URI}"

# Check the status of the job in the job list
gcloud scheduler jobs list --location=${REGION}

# To test the job, you can trigger it manually, overriding the schedule:
gcloud scheduler jobs run $JOB_NAME --location=$REGION

# Check the log of the Cloud Function:
gcloud functions logs read ${CLOUD_FUNCTION_NAME} --gen2 --region=${REGION}
gcloud beta run services logs tail ${CLOUD_FUNCTION_NAME} --project ${PROJECT_ID} --region ${REGION}