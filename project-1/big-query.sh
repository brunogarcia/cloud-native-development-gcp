# How to run
# ./update-tags.sh $BUCKET_NAME $FILE_NAME

export FILE_NAME=tags.csv
export PROJECT_ID=$(gcloud config get project)
export BUCKET_NAME="${PROJECT_ID}-skillsmapper-tags"

# 1) Create a file with the list of tags

# First, use the bq command to run a query against the Stack Overflow dataset to get a list of all the tags:
bq query --max_rows=100000 \
  --nouse_legacy_sql \
  --format=csv \
  "SELECT tag_name FROM bigquery-public-data.stackoverflow.tags order by tag_name" >$FILE_NAME

# You can check that it was successful by listing the number of lines in the file:
wc -l $FILE_NAME

# 2) Create a new bucket and copy the file to the bucket

# Then use the gsutil command to create the new bucket:
gsutil mb gs://$BUCKET_NAME

# With the bucket created, you can then copy the file containing the list of tags to the bucket:
gsutil cp $FILE_NAME gs://$BUCKET_NAME/$FILE_NAME

# You can check that the file was copied successfully by listing the number of lines in the file in the bucket:
gsutil cat gs://$BUCKET_NAME/$FILE_NAME | wc -l

