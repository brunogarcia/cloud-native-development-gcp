gcloud services enable sqladmin.googleapis.com

export INSTANCE_NAME='facts-instance'
export DATABASE_TIER='db-f1-micro'
export DISK_SIZE=10

export DATABASE_NAME='facts'
export FACT_SERVICE_DB_USER=
export FACT_SERVICE_DB_PASSWORD=

export REGION=$(gcloud config get functions/region)

# Create a new instance of PostgreSQL on Cloud SQL
gcloud sql instances create $INSTANCE_NAME \
    --database-version=POSTGRES_14 \
    --tier=$DATABASE_TIER \
    --region=$REGION \
    --availability-type=REGIONAL \
    --storage-size=$DISK_SIZE

# Create the database
gcloud sql databases create $DATABASE_NAME --instance=$INSTANCE_NAME

# Create a user
gcloud sql users create $FACT_SERVICE_DB_USER \
    --instance=$INSTANCE_NAME \
    --password=$FACT_SERVICE_DB_PASSWORD