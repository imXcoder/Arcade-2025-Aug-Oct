#!/bin/bash

PURPLE_COLOR=$'\033[0;35m'
GOLD_COLOR=$'\033[0;33m'
TEAL_COLOR=$'\033[0;36m'
LIME_COLOR=$'\033[0;92m'
MAROON_COLOR=$'\033[0;91m'
NAVY_COLOR=$'\033[0;94m'
NO_COLOR=$'\033[0m'
BOLD_TEXT=`tput bold`
RESET_FORMAT=`tput sgr0`

echo
echo "${PURPLE_COLOR}${BOLD_TEXT}=============================================${RESET_FORMAT}"
echo "${PURPLE_COLOR}${BOLD_TEXT}            GOOGLE CLOUD ARCADE 2025         ${RESET_FORMAT}"
echo "${PURPLE_COLOR}${BOLD_TEXT}=============================================${RESET_FORMAT}"
echo

echo -e "${GOLD_COLOR}${BOLD_TEXT}Enter the region: ${NO_COLOR}${RESET_FORMAT}"
read REGION

echo -e "${GOLD_COLOR}${BOLD_TEXT}Enter the message: ${NO_COLOR}${RESET_FORMAT}"
read MESSAGE

ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)')"

echo "${TEAL_COLOR}${BOLD_TEXT}Enabling App Engine API...${RESET_FORMAT}"
gcloud services enable appengine.googleapis.com

sleep 10

echo "${LIME_COLOR}${BOLD_TEXT}Configuring lab setup instance...${RESET_FORMAT}"
gcloud compute ssh --zone "$ZONE" "lab-setup" --project "$DEVSHELL_PROJECT_ID" --quiet --command "gcloud services enable appengine.googleapis.com && git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git"

echo "${TEAL_COLOR}${BOLD_TEXT}Cloning sample repository...${RESET_FORMAT}"
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git

cd python-docs-samples/appengine/standard_python3/hello_world

echo "${LIME_COLOR}${BOLD_TEXT}Updating application message...${RESET_FORMAT}"
sed -i "32c\    return \"$MESSAGE\"" main.py

if [ "$REGION" == "us-west" ]; then
  REGION="us-west1"
fi

echo "${NAVY_COLOR}${BOLD_TEXT}Creating App Engine application...${RESET_FORMAT}"
gcloud app create --service-account=$DEVSHELL_PROJECT_ID@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --region=$REGION

echo "${TEAL_COLOR}${BOLD_TEXT}Deploying application...${RESET_FORMAT}"
gcloud app deploy --quiet

echo "${LIME_COLOR}${BOLD_TEXT}Finalizing lab setup...${RESET_FORMAT}"
gcloud compute ssh --zone "$ZONE" "lab-setup" --project "$DEVSHELL_PROJECT_ID" --quiet --command "gcloud services enable appengine.googleapis.com && git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git"

echo
echo "${PURPLE_COLOR}${BOLD_TEXT}=============================================${RESET_FORMAT}"
echo "${PURPLE_COLOR}${BOLD_TEXT}            GOOGLE CLOUD ARCADE 2025         ${RESET_FORMAT}"
echo "${PURPLE_COLOR}${BOLD_TEXT}=============================================${RESET_FORMAT}"
echo
