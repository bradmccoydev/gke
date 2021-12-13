module "google_container_registry" {
  source   = "github.com/bradmccoydev/terraform-modules//google/google_container_registry"
  count    = var.cloud_container_registry_enabled ? 1 : 0
  project  = local.shared_name
  location = "US"
}