export FACT_SERVICE_SA=fact-service-sa
export FACT_CHANGED_TOPIC=fact-changed
export PROFILE_SERVICE_NAME=profile-service
export FACT_CHANGED_SUBSCRIPTION=fact-changed-subscription
export PROFILE_SERVICE_URL=$(gcloud run services describe $PROFILE_SERVICE_NAME --region=$REGION --format='value(status.url)')

export REGION=$(gcloud config get functions/region)
export PROJECT_ID=$(gcloud config get-value project)

gcloud services enable pubsub.googleapis.com

# Create a topic to send the “fact-changed” event to
gcloud pubsub topics create $FACT_CHANGED_TOPIC

# It is also a good idea to create a second topic to act as a dead letter queue.
# A dead letter queue is a place to capture messages that can’t be delivered. 
# This is useful as it means you can retry sending the message later or use the failed messages for debugging if there was a problem with the message content.
gcloud pubsub topics create $FACT_CHANGED_TOPIC-deadletter

# Add permissions to the service account that the fact service uses to allow it to publish messages to Pub/Sub.
# In this case, you need to add the roles/pubsub.publisher role to the service account like this:
gcloud pubsub topics add-iam-policy-binding ${FACT_CHANGED_TOPIC} \
  --member=serviceAccount:${FACT_SERVICE_SA}@${PROJECT_ID}.iam.gserviceaccount.com \
  --role=roles/pubsub.publisher

# Create the subscription with this command
gcloud pubsub subscriptions create ${FACT_CHANGED_SUBSCRIPTION} \
  --topic=${FACT_CHANGED_TOPIC} \
  --push-endpoint=${PROFILE_SERVICE_URL}/factschanged \
  --max-delivery-attempts=5 \
  --dead-letter-topic=$FACT_CHANGED_TOPIC-deadletter \
  --push-auth-service-account=${FACT_CHANGED_SUBSCRIPTION}-sa@${PROJECT_ID}.iam.gserviceaccount.com

# To delete the subscription, you can use the following command:
gcloud pubsub subscriptions delete $FACT_CHANGED_SUBSCRIPTION

