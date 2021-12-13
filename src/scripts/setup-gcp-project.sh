#!/usr/bin/env bash

export client_id=oc
export client_project_id=devops
export client_environment=dev

export GOOGLE_CLOUD_PROJECT=$client_id-$client_project_id-$client_environment
export ACCOUNT_ID=$(gcloud beta billing accounts list | grep True | cut -d ' ' -f1)
export REGION=us-west1
export SERVICE_ACCOUNT=$client_id-$client_project_id-$client_environment

echo "Environment Variables set $GOOGLE_CLOUD_PROJECT $ACCOUNT_ID $REGION $SERVICE_ACCOUNT"

set -e

if [[ -z "${GOOGLE_CLOUD_PROJECT}" ]]; then
  echo "Please make sure GOOGLE_CLOUD_PROJECT is defined before running this script."
  exit 1
fi

gcloud projects create $GOOGLE_CLOUD_PROJECT
gcloud config set compute/region $REGION
gcloud config set project $GOOGLE_CLOUD_PROJECT

gcloud beta billing projects link $GOOGLE_CLOUD_PROJECT \
  --billing-account=$ACCOUNT_ID

gcloud iam service-accounts create $SERVICE_ACCOUNT \
    --description="Automation Service Account" \
    --display-name="$GOOGLE_CLOUD_PROJECT"

echo "Enabling the Cloud APIs for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable cloudapis.googleapis.com

echo "Enabling the Cloud Resource Manager API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable cloudresourcemanager.googleapis.com

echo "Enabling the Cloud Build API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable cloudbuild.googleapis.com

echo "Enabling the Container Registry API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable containerregistry.googleapis.com

echo "Enabling the Cloud Run API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable run.googleapis.com

echo "Enabling the Cloud Billing API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable cloudbilling.googleapis.com

echo "Enabling the Cloud IAM API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable iam.googleapis.com

echo "Enabling the Cloud Compute API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable compute.googleapis.com

echo "Enabling the Cloud Container API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable container.googleapis.com

echo "Enabling the SQL Admin API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable sqladmin.googleapis.com

echo "Enabling the Cloud Service Networking API for project $GOOGLE_CLOUD_PROJECT..."
gcloud services enable servicenetworking.googleapis.com

echo "Discovering Project ID for project $GOOGLE_CLOUD_PROJECT..."
PROJECT_NUM=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format='value(projectNumber)')

echo "Got project number: ${PROJECT_NUM}"

gsutil mb -c standard -l $REGION gs://$GOOGLE_CLOUD_PROJECT
gsutil versioning set on gs://$GOOGLE_CLOUD_PROJECT/

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
  --member serviceAccount:$SERVICE_ACCOUNT@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role roles/owner

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
  --member user:brad@odysseycloud.io \
  --role roles/resourcemanager.projectIamAdmin

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
--member user:amit@odysseycloud.io \
--role roles/resourcemanager.projectIamAdmin

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
--member serviceAccount:$SERVICE_ACCOUNT@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
--role roles/container.admin

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
--member serviceAccount:$SERVICE_ACCOUNT@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
--role roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
--member serviceAccount:$SERVICE_ACCOUNT@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
--role roles/resourcemanager.projectIamAdmin

gcloud iam service-accounts keys create provision-gcp.json \
  --iam-account=$SERVICE_ACCOUNT@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --project $GOOGLE_CLOUD_PROJECT
