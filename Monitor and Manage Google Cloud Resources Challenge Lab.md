# Monitor and Manage Google Cloud Resources: Challenge Lab || [ARC101](https://www.cloudskillsboost.google/focuses/60441?parent=catalog) ||

## Youtube Video Link [here]()

### Run the following Commands in CloudShell

```
export USERNAME2=
export TOPIC_NAME=
```
```
BUCKET_NAME=travel-bucket-$DEVSHELL_PROJECT_ID
SERVICE_ACCOUNT="$(gsutil kms serviceaccount -p $DEVSHELL_PROJECT_ID)"

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com

sleep 20

gsutil mb gs://$BUCKET_NAME
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member=user:$USERNAME2 \
--role="roles/storage.objectViewer"

gcloud pubsub topics create $TOPIC_NAME

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:$SERVICE_ACCOUNT \
  --role=roles/artifactregistry.reader

 sleep 10

```
> Search ```Cloud Functions``` > click on CREATE FUNCTION
> Select Environment as ``2nd gen``
> For ``Function name`` copy the name from ``Task 3 First line``
> For ``Region`` select the default region
> In `Trigger` > For ``Trigger type`` > select ``Cloud Storage``
> For ``Event Type`` > select `google.cloud.storage.object.v1.finalized`
> For ``Bucket`` > click on ```BROWSE``` > click on the bucket name(starting with ```travel-bucket```) > then ``SELECT``
> Click on `MORE OPTIONS`
> Scroll down and `GRANT` all the permissions one by one
> If fail ``Grant``that permission again until nothing left
> Then ``SAVE TRIGGER``
> Click on ``GRANT ALL``
> For `` Runtime, build, connections and security settings ``
> In ``Autoscaling`` set the ```Maximum number of instances``` > `5`
> Scroll down and Click ```NEXT```

> For ``Runtime`` > select ``Node.js 20``
> For ``Entry point`` paste `thumbnail`
> Click on ``index.js`` > Paste this code
```
/* globals exports, require */
//jshint strict: false
//jshint esversion: 6
"use strict";
const crc32 = require("fast-crc32c");
const { Storage } = require('@google-cloud/storage');
const gcs = new Storage();
const { PubSub } = require('@google-cloud/pubsub');
const imagemagick = require("imagemagick-stream");

exports.thumbnail = (event, context) => {
  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64"
  const bucket = gcs.bucket(bucketName);
  const topicName = "REPLACE_WITH_YOUR_TOPIC ID";
  const pubsub = new PubSub();
  if ( fileName.search("64x64_thumbnail") == -1 ){
    // doesn't have a thumbnail, get the filename extension
    var filename_split = fileName.split('.');
    var filename_ext = filename_split[filename_split.length - 1];
    var filename_without_ext = fileName.substring(0, fileName.length - filename_ext.length );
    if (filename_ext.toLowerCase() == 'png' || filename_ext.toLowerCase() == 'jpg'){
      // only support png and jpg at this point
      console.log(`Processing Original: gs://${bucketName}/${fileName}`);
      const gcsObject = bucket.file(fileName);
      let newFilename = filename_without_ext + size + '_thumbnail.' + filename_ext;
      let gcsNewObject = bucket.file(newFilename);
      let srcStream = gcsObject.createReadStream();
      let dstStream = gcsNewObject.createWriteStream();
      let resize = imagemagick().resize(size).quality(90);
      srcStream.pipe(resize).pipe(dstStream);
      return new Promise((resolve, reject) => {
        dstStream
          .on("error", (err) => {
            console.log(`Error: ${err}`);
            reject(err);
          })
          .on("finish", () => {
            console.log(`Success: ${fileName} → ${newFilename}`);
              // set the content-type
              gcsNewObject.setMetadata(
              {
                contentType: 'image/'+ filename_ext.toLowerCase()
              }, function(err, apiResponse) {});
              pubsub
                .topic(topicName)
                .publisher()
                .publish(Buffer.from(newFilename))
                .then(messageId => {
                  console.log(`Message ${messageId} published.`);
                })
                .catch(err => {
                  console.error('ERROR:', err);
                });
          });
      });
    }
    else {
      console.log(`gs://${bucketName}/${fileName} is not an image I can handle`);
    }
  }
  else {
    console.log(`gs://${bucketName}/${fileName} already has a thumbnail`);
  }
};
```
> Replace the text ``REPLACE_WITH_YOUR_TOPIC ID`` in line 16 in this code with your ```topic name``` given in ```task 2```
> Select ``package.json`` > Paste the code
```
{
  "name": "thumbnails",
  "version": "1.0.0",
  "description": "Create Thumbnail of uploaded image",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@google-cloud/pubsub": "^2.0.0",
    "@google-cloud/storage": "^5.0.0",
    "fast-crc32c": "1.0.4",
    "imagemagick-stream": "4.1.1"
  },
  "devDependencies": {},
  "engines": {
    "node": ">=4.3.2"
  }
}
```
> Click on `DEPLOY`
> If it fails click on ``DEPLOY`` again.

### Run the following Commands in CloudShell
```
wget https://storage.googleapis.com/cloud-training/arc101/travel.jpg
gsutil cp travel.jpg gs://$BUCKET_NAME

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:$SERVICE_ACCOUNT \
  --role=roles/artifactregistry.reader

 sleep 10

cat > app-engine-error-percent-policy.json <<EOF_END
{
    "displayName": "Active Cloud Function Instances",
    "userLabels": {},
    "conditions": [
      {
        "displayName": "Cloud Function - Active instances",
        "conditionThreshold": {
          "filter": "resource.type = \"cloud_function\" AND metric.type = \"cloudfunctions.googleapis.com/function/active_instances\"",
          "aggregations": [
            {
              "alignmentPeriod": "300s",
              "crossSeriesReducer": "REDUCE_NONE",
              "perSeriesAligner": "ALIGN_MEAN"
            }
          ],
          "comparison": "COMPARISON_GT",
          "duration": "0s",
          "trigger": {
            "count": 1
          },
          "thresholdValue": 1
        }
      }
    ],
    "alertStrategy": {
      "autoClose": "604800s"
    },
    "combiner": "OR",
    "enabled": true,
    "notificationChannels": [],
    "severity": "SEVERITY_UNSPECIFIED"
  }
EOF_END


gcloud alpha monitoring policies create --policy-from-file="app-engine-error-percent-policy.json"

sleep 30

```

### Congratulations 🎉 for completing the Lab !

##### *You Have Successfully Demonstrated Your Skills And Determination.*

### *Let's connect together in [Linkedin](https://www.linkedin.com/in/soumen-kumar-26364a271/)*
