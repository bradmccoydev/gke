terraform {
  backend "azurerm" {
    resource_group_name  = "devops-prod"
    storage_account_name = "moulainfrastate"
    container_name       = "moula-training"
    key                  = "hashicorp-lab-gke.tfstate"
  }
}

provider "google" {
  credentials = file(var.cloud_credentials)
  project     = var.client_project_id
  region      = var.cloud_location_1.name
}

provider "google-beta" {
  credentials = file(var.cloud_credentials)
  project     = var.client_project_id
  region      = var.cloud_location_1.name
}
