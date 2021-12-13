module "vpc_network" {
  source                  = "github.com/bradmccoydev/terraform-modules//google/google_compute_network"
  project_id              = local.shared_name
  vpc_network_name        = local.primary_name
  auto_create_subnetworks = true
}

module "google_compute_global_address" {
  source           = "github.com/bradmccoydev/terraform-modules//google/google_compute_global_address"
  project_id       = local.shared_name
  name             = local.primary_name
  vpc_network_name = module.vpc_network.id
}

module "google_service_networking_connection" {
  source                  = "github.com/bradmccoydev/terraform-modules//google/google_service_networking_connection"
  project_id              = local.shared_name
  vpc_network_name        = module.vpc_network.id
  reserved_peering_ranges = module.google_compute_global_address.name
}

module "google_compute_address" {
  source     = "github.com/bradmccoydev/terraform-modules//google/google_compute_address"
  project_id = local.shared_name
  name       = local.primary_name
  region     = "us-west1" // TODO: investigate var.cloud_location_1.region
}
