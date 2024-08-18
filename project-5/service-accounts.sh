# Create a new service account for the UI with the following command, but do not give it any permissions
gcloud iam service-accounts create ${UI_SERVICE_NAME}-sa \
    --display-name "${UI_SERVICE_NAME} service account"