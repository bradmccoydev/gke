# GCP GKE Demo

# Requirements
terraform installed
gcloud installed with google cloud account

# Owner: brad@odysseycloud.io

State is stored in the following location:
Bucket:  oc-devops-dev
Prefix:  terraform/state/demo

** Delete .terraform folder first and lock file. **

gcloud auth login (DevOps account)

sudo sh setup-gcp-project.sh
chmod +x provision-gcp.json

# Must be in root directory of project

cd src && terraform init -var-file=deployment/demo.tfvars 

terraform plan -var-file=deployment/hugdemo.tfvars

terraform apply -var-file=deployment/hugdemo.tfvars

# Danger Zone
terraform destroy -var-file=deployment/demo.tfvars

# Connect to cluster
gcloud container clusters get-credentials devops-usw1-dev --project oc-devops-dev --region us-west1-a
