echo "Hello World" > random.txt
gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

gcloud eventarc triggers create trigger-auditlog \
  --destination-run-service=${SERVICE_NAME} \
  --event-filters="type=google.cloud.audit.log.v1.written" \
  --event-filters="serviceName=storage.googleapis.com" \
  --event-filters="methodName=storage.objects.create" \
  --service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com

  sleep 200

  gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

  sleep 10

  gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

  echo -e "\033[1;33mCongratulations 🎉 , you're all done with the lab !! \033[0m"  
