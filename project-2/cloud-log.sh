gcloud beta run services logs read $SKILL_SERVICE_NAME

gcloud logging read "resource.labels.service_name: ${SKILL_SERVICE_NAME}" --limit 1

gcloud logging read "resource.labels.service_name: ${SKILL_SERVICE_NAME} \
    textPayload: populate tags took" --limit 5 --freshness 1m

gcloud logging read "resource.labels.service_name: ${SKILL_SERVICE_NAME} \
    textPayload: populate tags took" --limit 5 --freshness 1m --format="value(textPayload)"
