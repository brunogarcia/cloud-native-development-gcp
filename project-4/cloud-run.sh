export PROFILE_SERVICE_SA=profile-service-sa
export PROFILE_SERVICE_NAME=profile-service
export FACT_CHANGED_SUBSCRIPTION=fact-changed-subscription

export REGION=$(gcloud config get functions/region)
export PROJECT_ID=$(gcloud config get-value project)

gcloud run deploy $PROFILE_SERVICE_NAME --source . \
  --region=$REGION \
  --service-account $PROFILE_SERVICE_SA@$PROJECT_ID.iam.gserviceaccount.com \
  --env-vars-file=env.yaml \
  --allow-unauthenticated

gcloud run services add-iam-policy-binding $PROFILE_SERVICE_NAME \
  --region=$REGION \
  --member=serviceAccount:${FACT_CHANGED_SUBSCRIPTION}-sa@${PROJECT_ID}.iam.gserviceaccount.com \
  --role=roles/run.invoker

# Test the Profile Service

# Go to Identity Providers -> Application Setup Details -> apy key
export API_KEY=

# Request an ID token
export ID_TOKEN=$(curl "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${API_KEY}" \
-H "Content-Type: application/json" --data-binary \
"{\"email\":\"${TEST_EMAIL}\",\"password\":\"${TEST_PASSWORD}\",\"returnSecureToken\":true}" \
| jq -r '.idToken')

payload=$(echo $ID_TOKEN | cut -d"." -f2)
decoded=$(echo $payload | base64 -d 2>/dev/null || echo $payload | base64 -di)
export USER_ID=$(echo $decoded | jq -r .user_id)

# Go to skillsmapper/profile-service/ and run the following command
envsubst < examples/fact-changed.json.template > examples/fact-changed.json

# Now publish the example fact-changed event for the test user using:
gcloud pubsub topics publish $FACT_CHANGED_TOPIC --message "$(cat examples/fact-changed.json)"

# Then check the log for the profile service to see the message it received:
gcloud beta run services logs read $PROFILE_SERVICE_NAME --region=$REGION

# Retrieve a profile for the current user
curl -X GET -H "Authorization: Bearer ${ID_TOKEN}" ${PROFILE_SERVICE_URL}/api/profiles/me

