terraform {
  backend "gcs" {}
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
