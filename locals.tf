locals {
  issuers = {
    default = {
      name = "selfsigned-issuer"
    }
    ca = { # This value is only used when using the self-signed variant.
      name = "ca-issuer"
    }
    letsencrypt = {
      production = {
        name   = "letsencrypt-prod"
        email  = var.letsencrypt_issuer_email_main
        server = "https://acme-v02.api.letsencrypt.org/directory"
      }
      staging = {
        name   = "letsencrypt-staging"
        email  = var.letsencrypt_issuer_email_main
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
      }
    }
  }

  helm_values = [{
    cert-manager = {
      installCRDs = true
      securityContext = {
        fsGroup = 999
      }
      prometheus = {
        servicemonitor = {
          enabled = var.enable_service_monitor
        }
      }
      resources = {
        requests = { for k, v in var.resources.controller.requests : k => v if v != null }
        limits   = { for k, v in var.resources.controller.limits : k => v if v != null }
      }
      webhook = {
        resources = {
          requests = { for k, v in var.resources.webhook.requests : k => v if v != null }
          limits   = { for k, v in var.resources.webhook.limits : k => v if v != null }
        }
      }
      cainjector = {
        resources = {
          requests = { for k, v in var.resources.cainjector.requests : k => v if v != null }
          limits   = { for k, v in var.resources.cainjector.limits : k => v if v != null }
        }
      }
      startupapicheck = {
        resources = {
          requests = { for k, v in var.resources.startupapicheck.requests : k => v if v != null }
          limits   = { for k, v in var.resources.startupapicheck.limits : k => v if v != null }
        }
      }
    }
    issuers = {
      default = local.issuers.default
      ca      = local.issuers.ca
      letsencrypt = { for issuer_id, issuer in local.issuers.letsencrypt :
        issuer.name => {
          email  = issuer.email
          server = issuer.server
        }
      }
    }
  }]
}
