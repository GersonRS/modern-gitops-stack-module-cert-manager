locals {
  helm_values = [{
    cert-manager = {
      clusterIssuers = {
        letsencrypt = {
          enabled = true
        }
        acme = {
          solvers = [
            {
              http01 = {
                ingress = {}
              }
            }
          ]
        }
      }
    }
  }]
}
