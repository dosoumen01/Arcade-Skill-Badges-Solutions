echo "Hello World" > random.txt

gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

export SERVICE_NAME=event-display

export PROJECT_NUMBER="$(gcloud projects list \
  --filter=$(gcloud config get-value project) \
  --format='value(PROJECT_NUMBER)')"
  
gcloud eventarc providers describe cloudaudit.googleapis.com

gcloud eventarc triggers create trigger-auditlog \
  --destination-run-service=${SERVICE_NAME} \
  --event-filters="type=google.cloud.audit.log.v1.written" \
  --event-filters="serviceName=storage.googleapis.com" \
  --event-filters="methodName=storage.objects.create" \
  --service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com

  sleep 180

  gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

  sleep 10

  gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

  echo -e "\033[1;33mCongratulations 🎉 , You're All Done With The Lab !! \033[0m"  
