gcloud config set project $DEVSHELL_PROJECT_ID
gcloud config set run/region $REGION
gcloud config set run/platform managed
gcloud config set eventarc/location $REGION

export PROJECT_NUMBER="$(gcloud projects list \
  --filter=$(gcloud config get-value project) \
  --format='value(PROJECT_NUMBER)')"

  gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --role='roles/eventarc.admin'

  sleep 10

  export SERVICE_NAME=event-display
  
  export IMAGE_NAME="gcr.io/cloudrun/hello"
  
  gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE_NAME} \
  --allow-unauthenticated \
  --max-instances=3

  sleep 10

  gcloud eventarc providers describe \
  pubsub.googleapis.com

  gcloud eventarc triggers create trigger-pubsub \
  --destination-run-service=${SERVICE_NAME} \
  --event-filters="type=google.cloud.pubsub.topic.v1.messagePublished"

  export TOPIC_ID=$(gcloud eventarc triggers describe trigger-pubsub \
  --format='value(transport.pubsub.topic)')

  echo ${TOPIC_ID}

  sleep 120

  gcloud pubsub topics publish ${TOPIC_ID} --message="Hello there"

  export BUCKET_NAME=$DEVSHELL_PROJECT_ID-cr-bucket
  
  gsutil mb -p $DEVSHELL_PROJECT_ID \
  -l $REGION \
  gs://${BUCKET_NAME}/

echo -e "\033[1;32mENABLE THE Admin Read, Data Read, Data Write FOR Google Cloud Storage BY GO THROGH THE LINK >> \033[1;34mhttps://console.cloud.google.com/iam-admin/audit? \033[0m"

echo -e "\033[1;33mFOR VIDEO ASSISTANT CLICK ON THE LINK >> \033[1;31mhttps://youtu.be/m5vY0yEfyD4?si=rZcT7tIlrrow1wWM&t=375 \033[0m"
