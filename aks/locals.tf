locals {

  default_solvers = {
    dns01 = {
      dns01 = {
        azureDNS = {
          subscriptionID    = split("/", data.azurerm_subscription.primary.id)[2]
          resourceGroupName = var.dns_zone_resource_group_name
          hostedZoneName    = var.base_domain
          # Azure Cloud Environment, default to AzurePublicCloud
          environment = "AzurePublicCloud"
        }
      }
      selector = {
        dnsZones = [var.base_domain]
      }
    }
    http01 = {
      http01 = {
        ingress = {}
      }
    }
  }

  use_default_solvers = {
    dns01  = var.use_default_dns01_solver
    http01 = var.use_default_http01_solver
  }

  solvers = concat(
    [for each in ["dns01", "http01"] : local.default_solvers[each] if local.use_default_solvers[each]],
    var.custom_solver_configurations
  )

  helm_values = [{
    cert-manager = {
      podLabels = {
        "azure.workload.identity/use" = "true"
      }
      serviceAccount = {
        create = true
        name   = "cert-manager"
        annotations = {
          "azure.workload.identity/client-id" = azurerm_user_assigned_identity.cert_manager.client_id
        }
      }
      clusterIssuers = {
        letsencrypt = {
          enabled = true
        }
        acme = {
          solvers = local.solvers
        }
      }
      replicaCount = 2
      resources = {
        limits = {
          memory = "128Mi"
        }
        requests = {
          cpu    = "10m"
          memory = "32Mi"
        }
      }

      webhook = {
        replicaCount = 2
        resources = {
          limits = {
            memory = "64Mi"
          }
          requests = {
            cpu    = "10m"
            memory = "32Mi"
          }
        }
      }

      cainjector = {
        replicaCount = 2
        resources = {
          limits = {
            memory = "128Mi"
          }
          requests = {
            cpu    = "10m"
            memory = "32Mi"
          }
        }
      }
    }
  }]
}
