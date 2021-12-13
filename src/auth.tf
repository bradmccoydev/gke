# ---------------------------------------------------------------------------------------------------------------------
# IAM OWNER
# ---------------------------------------------------------------------------------------------------------------------

module "service_account_owner" {
  source             = "github.com/bradmccoydev/terraform-modules//google/google_service_account"
  project_id         = local.shared_name
  service_account_id = "${var.client_id}-${local.shared_name}-owner"
  display_name       = "${local.shared_name} Owner RBAC"
}

module "service_account_key" {
  source               = "github.com/bradmccoydev/terraform-modules//google/google_service_account_key"
  service_account_name = module.service_account_owner[0].name
}

module "google_project_iam_member" {
  source  = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_member"
  project = local.shared_name
  role    = "roles/dns.admin"
  type    = "serviceAccount"
  user    = module.service_account_owner[0].email
}

module "iam_binding_compute_network_admin" {
  source     = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_binding"
  project_id = local.shared_name
  role       = "roles/compute.networkAdmin"
  member     = module.service_account_owner[0].email
}

module "iam_binding_compute" {
  source     = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_binding"
  project_id = local.shared_name
  role       = "roles/compute.admin"
  member     = module.service_account_owner[0].email
}

module "iam_binding_container" {
  source     = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_binding"
  project_id = local.shared_name
  role       = "roles/container.admin"
  member     = module.service_account_owner[0].email
}

module "iam_binding_service_account_user" {
  source     = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_binding"
  project_id = local.shared_name
  role       = "roles/iam.serviceAccountUser"
  member     = module.service_account_owner[0].email
}

module "iam_binding_project_iam_admin" {
  source     = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_binding"
  project_id = local.shared_name
  role       = "roles/resourcemanager.projectIamAdmin"
  member     = module.service_account_owner[0].email
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM OWNER
# ---------------------------------------------------------------------------------------------------------------------

module "service_account_cicd" {
  source             = "github.com/bradmccoydev/terraform-modules//google/google_service_account"
  count              = var.cloud_provider == "GCP" ? 1 : 0
  project_id         = local.shared_name
  service_account_id = "${local.shared_name}-cicd"
  display_name       = "${local.shared_name} CI/CD"
}

module "iam_binding_container_cicd" {
  source     = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_binding"
  project_id = local.shared_name
  role       = "roles/container.admin"
  member     = module.service_account_cicd[0].email
}

# ---------------------------------------------------------------------------------------------------------------------
# GCP IAM Admin, and Auditor
# ---------------------------------------------------------------------------------------------------------------------
module "service_account_auditor" {
  source             = "github.com/bradmccoydev/terraform-modules//google/google_service_account"
  count              = var.cloud_provider == "GCP" ? 1 : 0
  project_id         = local.shared_name
  service_account_id = "${local.shared_name}-auditor"
  display_name       = "${local.shared_name} Auditor RBAC"
}

module "service_account_admin" {
  source             = "github.com/bradmccoydev/terraform-modules//google/google_service_account"
  count              = var.cloud_provider == "GCP" ? 1 : 0
  project_id         = local.shared_name
  service_account_id = "${local.shared_name}-admin"
  display_name       = "${local.shared_name} Admin RBAC"
}

module "iam_kube_api_ro" {
  source      = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_custom_role"
  count       = var.cloud_provider == "GCP" ? 1 : 0
  role_id     = "kube_api_ro" // ${module.random_string.result}" //cant contain - //TODO CHange on next destroy
  project_id  = local.shared_name
  title       = "Kubernetes API (RO)"
  description = "Grants read-only API access that can be further restricted with RBAC"
  permissions = [
    "container.apiServices.get",
    "container.apiServices.list",
    "container.clusters.get",
    "container.clusters.getCredentials",
  ]
}
module "google_project_iam_member_user" {
  source  = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_member"
  count   = var.cloud_provider == "GCP" ? 1 : 0
  project = local.shared_name
  role    = module.iam_kube_api_ro[0].id
  type    = "user"
  user    = "brad@odysseycloud.io"
}

module "google_project_iam_member_user_amit" {
  source  = "github.com/bradmccoydev/terraform-modules//google/google_project_iam_member"
  count   = var.cloud_provider == "GCP" ? 1 : 0
  project = local.shared_name
  role    = module.iam_kube_api_ro[0].id
  type    = "user"
  user    = "amit@odysseycloud.io"
}

module "google_storage_bucket_iam_member" {
  source    = "github.com/bradmccoydev/terraform-modules//google/google_storage_bucket_iam_member"
  bucket_id = module.google_container_registry[0].id
  role      = "roles/storage.objectAdmin"
  member    = "user:brad@odysseycloud.io"
}

module "google_storage_bucket_iam_member_sa" {
  source    = "github.com/bradmccoydev/terraform-modules//google/google_storage_bucket_iam_member"
  count     = var.cloud_container_registry_enabled ? 1 : 0
  bucket_id = module.google_container_registry[0].id
  role      = "roles/storage.objectAdmin"
  member    = "serviceAccount:${module.service_account_owner[0].email}"
  depends_on = [
    module.service_account_owner
  ]
}
