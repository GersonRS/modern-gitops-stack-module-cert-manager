output "id" {
  description = "ID to pass other modules in order to refer to this module as a dependency."
  value       = module.cert-manager.id
}

output "cluster_issuers" {
  description = "List of cluster issuers created by cert-manager."
  value       = module.cert-manager.cluster_issuers
}
