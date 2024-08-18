export PROJECT_ID=$(gcloud config get-value project)
export SERVICE_NAME='facts-service'
export VERSION='v1'

gcloud container images push gcr.io/${PROJECT_ID}/${SERVICE_NAME}:${VERSION}
