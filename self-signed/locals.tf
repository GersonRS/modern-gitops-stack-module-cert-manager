locals {
  helm_values = [{
    cert-manager = {}

    # This structure will be merged with the one with the same name on the root locals.tf.
    clusterIssuers = {
      ca = {
        tlsCrt = base64encode(tls_self_signed_cert.root.cert_pem)
        tlsKey = base64encode(tls_private_key.root.private_key_pem)
      }
    }
  }]
}
