#!/bin/bash

YELLOW='\033[0;33m'
NC='\033[0m' 

pattern=(
"**********************************************************"
"**               G O O G L E   C L O U D                **"
"**                A R C A D E   2 0 2 5                 **"
"**                 ( A U G  -  O C T )                  **"
"**********************************************************"
)
gcloud config set compute/region $LOCATION
gsutil mb gs://$DEVSHELL_PROJECT_ID-bucket/
gcloud services disable dataflow.googleapis.com
sleep 20
gcloud services enable dataflow.googleapis.com
sleep 20
docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID -e LOCATION=$LOCATION python:3.9 /bin/bash -c '
pip install "apache-beam[gcp]"==2.42.0 && \
python -m apache_beam.examples.wordcount --output OUTPUT_FILE && \
HUSTLER=gs://$DEVSHELL_PROJECT_ID-bucket && \
python -m apache_beam.examples.wordcount --project $DEVSHELL_PROJECT_ID \
  --runner DataflowRunner \
  --staging_location $HUSTLER/staging \
  --temp_location $HUSTLER/temp \
  --output $HUSTLER/results/output \
  --region $LOCATION
'
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done
pattern=(
"**********************************************************"
"**               G O O G L E   C L O U D                **"
"**                A R C A D E   2 0 2 5                 **"
"**                 ( A U G  -  O C T )                  **"
"**********************************************************"
)
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done
