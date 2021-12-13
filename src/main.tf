# ---------------------------------------------------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------------------------------------------------
# GKE
# ---------------------------------------------------------------------------------------------------------------------

module "random_password" {
  source  = "github.com/bradmccoydev/terraform-modules//utils/random_password"
  length  = 16
  special = false
}
module "google_container_cluster" {
  source             = "github.com/bradmccoydev/terraform-modules//google/google_container_cluster"
  project_id         = local.shared_name
  cluster_name       = local.primary_name
  region             = var.cloud_location_1.name
  vpc_name           = module.vpc_network.self_link
  subnet_name        = local.primary_name
  initial_node_count = var.kubernetes_initial_node_count
  network_policy     = var.kubernetes_network_policy
  tags               = merge(local.tags, var.cloud_custom_tags)
}

module "google_container_node_pool" {
  source                    = "github.com/bradmccoydev/terraform-modules//google/google_container_node_pool"
  project_id                = local.shared_name
  region                    = var.cloud_location_1.name
  cluster_name              = module.google_container_cluster.kubernetes_cluster_name
  gke_num_nodes             = var.kubernetes_initial_node_count
  machine_type              = var.kubernetes_node_size
  max_node_count            = var.kubernetes_max_node_count
  kubernetes_node_disk_size = var.kubernetes_node_disk_size
  cloud_transient_instance  = var.cloud_transient_instance
}

module "google_container_registry" {
  source   = "github.com/bradmccoydev/terraform-modules//google/google_container_registry"
  count    = var.cloud_provider == "GCP" && var.cloud_container_registry_enabled ? 1 : 0
  project  = local.shared_name
  location = "US"
}


