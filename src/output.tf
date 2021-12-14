output "kube_config" {
    value = format("%s%s%s%s%s%s","gcloud container clusters get-credentials  ", "module.azurerm_resource_group.name", " --project ", "module.azurerm_kubernetes_cluster_primary.host", " --region ", "region here")
}
