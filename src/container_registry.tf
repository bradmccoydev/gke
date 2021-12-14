module "google_container_registry" {
  source   = "github.com/bradmccoydev/terraform-modules//google/google_container_registry"
  project  = local.shared_name
  location = "US"
}