terraform {
  backend "gcs" {
    credentials =  "./deployment/provision-gcp.json"
    bucket  = "oc-huggke-demo"
    prefix  = "terraform/state/demo"
  }
}