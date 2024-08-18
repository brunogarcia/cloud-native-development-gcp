# Project 1: Tag Updater with Cloud Functions

It will be introduced to some of the higher-level abstractions in Google Cloud and be shown how you can solve a real-world problem at a minimal cost.

[https://github.com/SkillsMapper/skillsmapper/tree/main/tag-updater](https://github.com/SkillsMapper/skillsmapper/tree/main/tag-updater)

- gcloud CLI is used for interacting with the Google Cloud API.
- gsutil is used for working with Cloud Storage.
- bq is used for working with BigQuery at the command line.
- BigQuery is used for querying the Stack Overflow public dataset.
- Cloud Storage is used as a simple way of storing the list of tags.
- Cloud Functions is used as a high-level abstraction to run code serverlessly.
- Cloud Scheduler is used as the mechanism scheduling runs of the job.

# Initial Setup

```bash
export PROJECT_ID=$(gcloud config get project)
export BUCKET_NAME="${PROJECT_ID}-skillsmapper-tags"
export REGION=$(gcloud config get functions/region)

envsubst < env.yaml.template > env.yaml

gcloud config set functions/region $REGION
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable run.googleapis.com
```
