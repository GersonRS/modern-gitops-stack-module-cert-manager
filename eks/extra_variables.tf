variable "cluster_name" {
  description = "The name of the Kubernetes cluster to create."
  type        = string
}

variable "base_domain" {
  description = "The base domain used for Ingresses."
  type        = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "other_domains" {
  description = "Other domains used for Ingresses requiring a DNS-01 challenge for Let's Encrypt validation with cert-manager (e.g. wildcard certificates)."
  type        = list(string)
  default     = []
}

variable "letsencrypt_issuer_email" {
  description = "E-mail address used to register with Let's Encrypt."
  type        = string
}
