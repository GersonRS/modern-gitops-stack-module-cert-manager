variable "cluster_name" {
  description = "The name of the Kubernetes cluster to create."
  type        = string
}

variable "base_domain" {
  description = "The base domain used for Ingresses."
  type        = string
}

variable "node_resource_group_name" {
  description = "The managed AKS resource group name."
  type        = string
}

variable "dns_zone_resource_group_name" {
  description = "The Azure DNS zone's resource group name."
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster."
  type        = string
}

variable "letsencrypt_issuer_email" {
  description = "E-mail address used to register with Let's Encrypt."
  type        = string
}
