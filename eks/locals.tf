locals {
  assumable_role_arn = var.base_domain == null ? "" : module.iam_assumable_role_cert_manager.0.iam_role_arn


  default_solvers = {
    dns01 = {
      dns01 = {
        route53 = {
          region = data.aws_region.current.name
        }
      }
      selector = {
        dnsZones = [for domain in local.all_domains : domain]
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
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = local.assumable_role_arn
        }
      }
    }

    # This structure will be merged with the one with the same name on the root locals.tf.
    clusterIssuers = {
      letsencrypt = {
        enabled = true
        acme = {
          solvers = local.solvers
        }
      }
    }
  }]
}
