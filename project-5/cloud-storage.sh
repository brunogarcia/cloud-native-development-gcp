# Create a new Cloud Storage bucket
gsutil mb -p ${PROJECT_ID} -c regional -l ${REGION} gs://${PROJECT_ID}-ui

# Clone the repository and copy the files to the bucket
git clone git@github.com:brunogarcia/skillsmapper.git
cd skillsmapper/user-interface/
gsutil -m cp -r ./src/* gs://${PROJECT_ID}-ui

# Grant everyone objectViewer read permissions to the bucket
gsutil iam ch allUsers:objectViewer gs://${PROJECT_ID}-ui

# Finally, enable the Website feature on the bucket, using index.html as the default web page and 404.html as the error page
gcloud storage buckets update gs://${PROJECT_ID}-ui \
    --web-main-page-suffix=index.html --web-error-page=404.html

# Set the Cache-Control metadata to public, max-age=0 for the index.html file
gsutil setmeta -h "Cache-Control:public, max-age=0" \
    gs://${PROJECT_ID}-ui/index.html
