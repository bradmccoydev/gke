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
