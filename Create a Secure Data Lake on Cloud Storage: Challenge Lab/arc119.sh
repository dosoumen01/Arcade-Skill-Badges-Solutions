# Function to handle different forms
handle_form() {
    case $1 in
        1)
            echo "Processing Form 1..."
            # FORM 1

#TASK 1

gcloud services enable dataplex.googleapis.com
export REGION=${ZONE::-2}

gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID-bucket

#TASK 2

gcloud dataplex lakes create customer-lake \
    --location=$REGION \
    --display-name="Customer-Lake"

gcloud dataplex zones create public-zone \
    --lake=customer-lake \
    --location=$REGION \
    --display-name="Public-Zone" \
    --type=RAW \
    --resource-location-type=SINGLE_REGION \
    --discovery-enabled \
    --labels="key_1=domain_type,value_1=source_data"

#TASK 3

gcloud dataplex environments create dataplex-lake-env \
    --project=$DEVSHELL_PROJECT_ID \
    --location=$REGION \
    --lake=customer-lake \
    --display-name="Dataplex-lake-env" \
    --compute-node-count 3 \
    --compute-max-node-count 3 \
    --os-image-version=1.0 

#TASK 4

#gcloud alpha data-catalog tag-templates create customer_data_tag_template \
  #  --location=$REGION \
 #   --project=$DEVSHELL_PROJECT_ID \
  #  --display-name="Customer Data Tag Template" \
  #  --field=id=Data_Owner,display-name="Data Owner",type=string \
  #  --field=id=PII_Data,display-name="PII Data",type='enum(YES|NO)'


echo -e "\033[1;32mDO THE TASK 4 MANUALLY WITH THE HELP OF LINK >> \033[1;34mhttps://console.cloud.google.com/dataplex/templates \033[0m"

echo -e "\033[1;33mFOR VIDEO ASSISTANT CLICK ON THE LINK >> \033[1;31mhttps://console.cloud.google.com \033[0m"

            ;;
            
        2)
            echo "Processing Form 2..."
            #FORM 2

#TASK 1

gcloud services enable dataplex.googleapis.com
export REGION=${ZONE::-2}

gcloud dataplex lakes create customer-lake \
    --location=$REGION \
    --display-name="Customer-Lake"

gcloud dataplex zones create public-zone \
    --lake=customer-lake \
    --location=$REGION \
    --display-name="Public-Zone" \
    --type=RAW \
    --resource-location-type=SINGLE_REGION \
    --discovery-enabled \
    --labels="key_1=domain_type,value_1=source_data"

#TASK 2

gcloud dataplex environments create dataplex-lake-env \
    --project=$DEVSHELL_PROJECT_ID \
    --location=$REGION \
    --lake=customer-lake \
    --display-name="Dataplex-lake-env" \
    --compute-node-count 3 \
    --compute-max-node-count 3 \
    --os-image-version=1.0 

#TASK 3

gcloud dataplex assets create customer-raw-data \
    --project=$DEVSHELL_PROJECT_ID \
    --location=$REGION \
    --lake=customer-lake \
    --zone=public-zone \
    --resource-type=STORAGE_BUCKET \
    --display-name="Customer Raw Data" \
    --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID-customer-bucket \
    --discovery-enabled

#TASK 4

#gcloud alpha data-catalog tag-templates create customer_data_tag_template \
  #  --location=$REGION \
 #   --project=$DEVSHELL_PROJECT_ID \
  #  --display-name="Customer Data Tag Template" \
  #  --field=id=Data_Owner,display-name="Data Owner",type=string \
  #  --field=id=PII_Data,display-name="PII Data",type='enum(YES|NO)'


echo -e "\033[1;32mDO THE TASK 4 MANUALLY WITH THE HELP OF LINK >> \033[1;34mhttps://console.cloud.google.com/dataplex/templates \033[0m"

echo -e "\033[1;33mFOR VIDEO ASSISTANT CLICK ON THE LINK >> \033[1;31mhttps://console.cloud.google.com \033[0m"
            ;;
            
        3)
            echo "Processing Form 3..."
            # FORM 3

#TASK 1

gcloud services enable dataplex.googleapis.com
export REGION=${ZONE::-2}

bq --location=$REGION mk -d Raw_data
bq --location=$REGION load --source_format=AVRO Raw_data.public-data gs://spls/gsp1145/users.avro

#TASK 2

gcloud dataplex zones create temperature-raw-data \
    --lake=public-lake \
    --location=$REGION \
    --type=RAW \
    --resource-location-type=SINGLE_REGION \
    --display-name="temperature raw data"

#TASK 3

gcloud dataplex assets create customer-details-dataset \
    --location=$REGION \
    --project=$DEVSHELL_PROJECT_ID \
    --lake=public-lake \
    --zone=temperature-raw-data \
    --resource-type=BIGQUERY_DATASET \
    --display-name="Customer Details Dataset" \
    --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customer_reference_data \
    --discovery-enabled

#TASK 4

gcloud beta data-catalog tag-templates create protected_data_template \
    --location=$REGION \
    --display-name="Protected Data Template" \
    --field=id=protected_data_flag,display-name="Protected Data Flag",type='enum(YES|NO)' 
            ;;
            
        4)
            echo "Processing Form 4..."
            #FORM 4

#TASK 1

gcloud services enable dataplex.googleapis.com
export REGION=${ZONE::-2}
gcloud dataplex lakes create customer-lake \
    --location=$REGION \
    --display-name="Customer-Lake"

gcloud dataplex zones create public-zone \
    --lake=customer-lake \
    --location=$REGION \
    --display-name="Public-Zone" \
    --type=RAW \
    --resource-location-type=SINGLE_REGION \
    --discovery-enabled \
    --labels="key_1=domain_type,value_1=source_data"

#TASK 2

gcloud dataplex assets create customer-raw-data \
    --project=$DEVSHELL_PROJECT_ID \
    --location=$REGION \
    --lake=customer-lake \
    --zone=public-zone \
    --resource-type=STORAGE_BUCKET \
    --display-name="Customer Raw Data" \
    --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID-customer-bucket \
    --discovery-enabled

#TASK 3

gcloud dataplex assets create customer-details-dataset \
    --location=$REGION \
    --project=$DEVSHELL_PROJECT_ID \
    --lake=customer-lake \
    --zone=public-zone \
    --resource-type=BIGQUERY_DATASET \
    --display-name="Customer Details Dataset" \
    --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customer_reference_data \
    --discovery-enabled

#TASK 4

echo -e "\033[1;32mDO THE TASK 4 MANUALLY WITH THE HELP OF MY VIDEO >> \033[1;34mhttps://console.cloud.google.com/ \033[0m"

            ;;
        *)
            echo "Invalid input. Please enter a valid Form Id (1, 2, 3, or 4)."
            ;;
    esac
}

# Prompt user to enter form number
read -p "Enter the Lab Form Id  (1, 2, 3, or 4): " form_id

# Display the form number entered by the user
echo "Form number entered: $form_id"

# Call function to handle the form based on user input
handle_form $form_id
