# Project 2: Skill Service with Cloud Run

- Cloud Run is used as the container runtime to run the containerized service.
- Cloud Logging is used to provide logging for the service.
- Cloud Storage is used to retrieve the previously stored list on tags.

## Getting Ready for Deployment

```bash
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set project $PROJECT_ID
```

## Cloud Run

You will deploy to Cloud Run using the default settings:

- 1 vCPU
- 512 MB memory
- Concurrency: 80
- Minimum instances: 0
- Maximum instances: 100

This command is a shortcut for two commands

```bash
gcloud run deploy
```

The first command builds a container using a buildpack using Cloud Build.

A buildpack is a concept that existed in both the Heroku and Cloud Foundry platforms.
It automatically identifies the application’s language, installs the necessary dependencies, and packages it all up into a container.

Cloud Run is using what is effectively version three of the buildpack concept, Cloud Native Buildpacks.

```bash
gcloud builds submit --pack image=[IMAGE] .
```

The second command is deploys the container to Cloud Run.

```bash
gcloud run deploy $SKILL_SERVICE_NAME --image [IMAGE]
```
