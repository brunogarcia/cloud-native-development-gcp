# Configures the API Gateway to route requests to the appropriate service
export API_NAME=skillmapper
export DOMAIN=

export FACT_SERVICE_NAME=facts-service
export SKILL_SERVICE_NAME=skill-service
export PROFILE_SERVICE_NAME=profile-service

export API_SPEC_FILE=api.yaml

export FACT_SERVICE_URL=$(gcloud run services describe ${FACT_SERVICE_NAME} --region $REGION --format 'value(status.url)')
export SKILL_SERVICE_URL=$(gcloud run services describe ${SKILL_SERVICE_NAME} --region $REGION --format 'value(status.url)')
export PROFILE_SERVICE_URL=$(gcloud run services describe ${PROFILE_SERVICE_NAME} --region $REGION --format 'value(status.url)')

envsubst < api.yaml.template > api.yaml

# Enable the required services
gcloud services enable apigateway.googleapis.com
gcloud services enable servicecontrol.googleapis.com

# Create a service account for the API Gateway
export API_GATEWAY_SA=${API_NAME}-gateway-sa
gcloud iam service-accounts create $API_GATEWAY_SA --display-name "Service account to invoke skillmapper services"

# Then give the service account permission to invoke each of the Cloud Run services in turn with the following commands.
gcloud run services add-iam-policy-binding $FACT_SERVICE_NAME \
    --region $REGION \
    --role roles/run.invoker \
    --member "serviceAccount:${API_GATEWAY_SA}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud run services add-iam-policy-binding $SKILL_SERVICE_NAME \
    --region $REGION \
    --role roles/run.invoker \
    --member "serviceAccount:${API_GATEWAY_SA}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud run services add-iam-policy-binding $PROFILE_SERVICE_NAME \
    --region $REGION \
    --role roles/run.invoker \
    --member "serviceAccount:${API_GATEWAY_SA}@${PROJECT_ID}.iam.gserviceaccount.com"

# Create an API Gateway configuration
gcloud api-gateway api-configs create ${API_NAME}-config \
    --api=${API_NAME} \
    --openapi-spec=${API_SPEC_FILE} \
    --project=${PROJECT_ID} \
    --backend-auth-service-account=$API_GATEWAY_SA@${PROJECT_ID}.iam.gserviceaccount.com

# Create the API Gateway service
gcloud api-gateway gateways create ${API_NAME}-gateway \
    --api=${API_NAME} \
    --api-config=${API_NAME}-config \
    --location=${REGION} \
    --project=${PROJECT_ID}

# Retrieve the URL of the API Gateway
export GATEWAY_URL=$(gcloud api-gateway gateways describe ${API_NAME}-gateway \
  --location=${REGION} \
  --project=${PROJECT_ID} \
  --format 'value(defaultHostname)')

# Test the API Gateway
curl -X GET "https://${GATEWAY_URL}/api/skills/autocomplete?prefix=java"

# Revoke the roles/run.invoker role from allUsers for the services
gcloud run services remove-iam-policy-binding $SKILL_SERVICE_NAME \
    --region $REGION \
    --role roles/run.invoker \
    --member "allUsers"

gcloud run services remove-iam-policy-binding $FACT_SERVICE_NAME \
    --region $REGION \
    --role roles/run.invoker \
    --member "allUsers"

gcloud run services remove-iam-policy-binding $PROFILE_SERVICE_NAME \
    --region $REGION \
    --role roles/run.invoker \
    --member "allUsers"