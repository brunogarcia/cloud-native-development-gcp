export REGION=$(gcloud config get functions/region)

gcloud services enable firestore.googleapis.com

# Create the Firestore database with --type=firestore-native to use Firestore Native mode
gcloud alpha firestore databases create --location=$REGION --type=firestore-native
