#######################
## Standard variables
#######################

variable "argocd_project" {
  description = "Name of the Argo CD AppProject where the Application should be created. If not set, the Application will be created in a new AppProject only for this Application."
  type        = string
  default     = null
}

variable "argocd_labels" {
  description = "Labels to attach to the Argo CD Application resource."
  type        = map(string)
  default     = {}
}

variable "destination_cluster" {
  description = "Destination cluster where the application should be deployed."
  type        = string
  default     = "in-cluster"
}

variable "target_revision" {
  description = "Override of target revision of the application chart."
  type        = string
  default     = "v1.1.0" # x-release-please-version
}

variable "enable_service_monitor" {
  description = "Enable Prometheus ServiceMonitor in the Helm chart."
  type        = bool
  default     = true
}

variable "helm_values" {
  description = "Helm values, passed as a list of HCL structures."
  type        = any
  default     = []
}

variable "deep_merge_append_list" {
  description = "A boolean flag to enable/disable appending lists instead of overwriting them."
  type        = bool
  default     = false
}

variable "app_autosync" {
  description = "Automated sync options for the Argo CD Application resource."
  type = object({
    allow_empty = optional(bool)
    prune       = optional(bool)
    self_heal   = optional(bool)
  })
  default = {
    allow_empty = false
    prune       = true
    self_heal   = true
  }
}

variable "dependency_ids" {
  description = "IDs of the other modules on which this module depends on."
  type        = map(string)
  default     = {}
}

#######################
## Module variables
#######################

variable "resources" {
  description = <<-EOT
    Resource limits and requests for cert-manager's components. Follow the style on https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/[official documentation] to understand the format of the values.

    IMPORTANT: These are not production values. You should always adjust them to your needs.
  EOT
  type = object({

    controller = optional(object({
      requests = optional(object({
        cpu    = optional(string, "50m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "128Mi")
      }), {})
    }), {})

    webhook = optional(object({
      requests = optional(object({
        cpu    = optional(string, "50m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "128Mi")
      }), {})
    }), {})

    cainjector = optional(object({
      requests = optional(object({
        cpu    = optional(string, "50m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "128Mi")
      }), {})
    }), {})

    startupapicheck = optional(object({
      requests = optional(object({
        cpu    = optional(string, "50m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "128Mi")
      }), {})
    }), {})

  })
  default = {}
}

variable "letsencrypt_issuer_email_main" {
  description = "E-mail address used to register with Let's Encrypt."
  type        = string
  default     = null # This value needs to be null and it is the variants job to make the outside variable required.
}

variable "use_default_dns01_solver" {
  description = "Whether to use the default dns01 solver configuration."
  type        = bool
  default     = true
}

variable "use_default_http01_solver" {
  description = "Whether to use the default http01 solver configuration."
  type        = bool
  default     = true
}

variable "custom_solver_configurations" {
  description = "List of additional solver configurations, appended to the default dns01 and http01 solvers (if enabled)."
  type        = list(any)
  default     = []
}
