export FACT_SERVICE_SA=fact-service-sa
export FACT_SERVICE_NAME=facts-service
export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud config get functions/region)
export FACT_SERVICE_URL=$(gcloud run services describe $FACT_SERVICE_NAME --region=$REGION --format='value(status.url)')

envsubst < env.yaml.template > env.yaml

# Create the fact service
gcloud run deploy $FACT_SERVICE_NAME --source . \
  --set-env-vars PROJECT_ID=$PROJECT_ID,SERVICE_NAME=$FACT_SERVICE_NAME,SPRING_PROFILES_ACTIVE=h2 \
  --allow-unauthenticated \
  --region=$REGION

# Update the fact service

gcloud run services update $FACT_SERVICE_NAME \
  --region=$REGION \
  --service-account ${FACT_SERVICE_SA}@${PROJECT_ID}.iam.gserviceaccount.com \
  --add-cloudsql-instances ${PROJECT_ID}:${REGION}:${INSTANCE_NAME} \
  --env-vars-file=env.yaml \
  --update-secrets=DATABASE_PASSWORD=${FACT_SERVICE_DB_PASSWORD_SECRET_NAME}:latest

# Go to Identity Providers -> Application Setup Details -> apy key
export API_KEY=

# Request an ID token
export ID_TOKEN=$(curl "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${API_KEY}" \
-H "Content-Type: application/json" --data-binary \
"{\"email\":\"${TEST_EMAIL}\",\"password\":\"${TEST_PASSWORD}\",\"returnSecureToken\":true}" \
| jq -r '.idToken')

# Test the fact service
curl -X GET ${FACT_SERVICE_URL}/api/facts \
  -H "Authorization: Bearer ${ID_TOKEN}"

curl -X POST \
  -H "Authorization: Bearer ${ID_TOKEN}" \
  -H 'Content-Type: application/json' \
  -d '{ "skill": "java", "level": "learning" }`' \
  ${FACT_SERVICE_URL}/api/facts

curl -X DELETE \
  -H "Authorization: Bearer ${ID_TOKEN}" \
  ${FACT_SERVICE_URL}/api/facts/1

