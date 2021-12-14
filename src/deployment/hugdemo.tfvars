client_id                   = "oc"
client_name                 = "odysseycloud"
client_project_id           = "devops"
client_project_admin        = "brad@odysseycloud.io"
client_environment          = "hugdemo"
client_project_dependencies = []

cloud_provider              = "GCP"
cloud_tenant_id             = ""
cloud_account_id            = "142035491160"
cloud_multi_region          = false 
cloud_custom_tags           = {}
cloud_credentials           = "./deployment/hugdemo/provision-gcp.json"
cloud_iam_role              = "odysseycloud"
cloud_transient_instance    = true

cloud_container_registry_enabled = true

cloud_bastion_enabled                    = false
cloud_network_cidr_range_bastion         = "10.0.0.0/16"
cloud_subnet_cidr_range_bastion_vm       = "10.0.0.0/24"
cloud_subnet_cidr_range_bastion_service  = "10.0.1.0/24"

cloud_network_cidr_range_kubernetes = "10.1.0.0/16"
cloud_subnet_cidr_range_kubernetes  = "192.168.10.0/24"
cloud_subnet_public_name_1          = "kubernetes"
cloud_subnet_public_cidr_1          = "10.1.10.0/24"
cloud_subnet_public_cidr_2          = "10.1.20.0/24"
cloud_subnet_private_cidr_1         = "10.1.50.0/24"
cloud_subnet_private_cidr_2         = "10.1.60.0/24"

cloud_location_1 = {
  name = "us-west1-a"
  region = "us-west1"
  alias = "usw1"
  cloud_location_zones = ["us-west1-a"]
}
cloud_location_2 = {
  name = "us-west2"
  region = "us-west1"
  alias = "usw2"
  cloud_location_zones = ["us-west2-a"]
}

kubernetes_node_size          = "e2-standard-2"
kubernetes_network_policy     = "calico"
kubernetes_node_disk_size     = 30
kubernetes_initial_node_count = 1
kubernetes_max_node_count     = 3
