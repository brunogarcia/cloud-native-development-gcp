# Set the environment variables
export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud config get functions/region)

# Then go to the Identity Platform configuration page (see Figure 9-3) for the project and copy the API Key. Click Application Setup Details and copy the value of the apiKey field.
export API_KEY=

# Clone the repository and create the config.js file
git clone git@github.com:brunogarcia/skillsmapper.git
cd skillsmapper/user-interface/
envsubst < config.js.template > src/js/config.js

# Build the container and push it to the Container Registry in the project
export UI_SERVICE_NAME=ui-service
gcloud builds submit --tag gcr.io/${PROJECT_ID}/${UI_SERVICE_NAME}

# Deploy the service to Cloud Run using the resulting container and the new service account
gcloud run deploy $UI_SERVICE_NAME \
    --region ${REGION} \
    --image gcr.io/${PROJECT_ID}/${UI_SERVICE_NAME} \
    --service-account ${UI_SERVICE_NAME}-sa@${PROJECT_ID}.iam.gserviceaccount.com \
    --allow-unauthenticated

# You can then retrieve the URL of the service with the following command
gcloud run services describe ${UI_SERVICE_NAME} --region=$REGION --format 'value(status.url)'

# Remove the UI service
gcloud run services delete ${UI_SERVICE_NAME}
