module "cert-manager" {
  source = "../"

  argocd_project         = var.argocd_project
  argocd_labels          = var.argocd_labels
  destination_cluster    = var.destination_cluster
  target_revision        = var.target_revision
  enable_service_monitor = var.enable_service_monitor
  deep_merge_append_list = var.deep_merge_append_list
  app_autosync           = var.app_autosync

  helm_values = concat(local.helm_values, var.helm_values)

  letsencrypt_issuer_email_main = var.letsencrypt_issuer_email

  dependency_ids = var.dependency_ids
}
