locals {
  issuers = flatten([
    for issuer_key, issuer in try(var.vault.issuers, {}) : {

      issuer_key    = issuer_key
      name          = "issuer-${var.workload}-${issuer_key}-${var.environment}"
      key_vault_id  = azurerm_key_vault.keyvault.id
      provider_name = issuer.provider
      account_id    = try(issuer.account_id, null)
      password      = try(issuer.password, null)
      org_id        = try(issuer.org_id, null)
    }
  ])
}

locals {
  keys = flatten([
    for k_key, k in try(var.vault.keys, {}) : {

      k_key           = k_key
      name            = k_key
      key_type        = k.key_type
      key_opts        = k.key_opts
      key_size        = try(k.key_size, null)
      curve           = try(k.curve, null)
      not_before_date = try(k.not_before_date, null)
      expiration_date = try(k.expiration_date, null)
      key_vault_id    = azurerm_key_vault.keyvault.id
      rotation_policy = try(k.rotation_policy, null)
    }
  ])
}

locals {
  secrets = flatten([
    for secret_key, secret in try(var.vault.secrets.random_string, {}) : {

      secret_key   = secret_key
      name         = secret_key
      length       = secret.length
      special      = try(secret.special, true)
      min_lower    = try(secret.min_lower, 5)
      min_upper    = try(secret.min_upper, 7)
      min_special  = try(secret.min_special, 4)
      min_numeric  = try(secret.min_numeric, 5)
      key_vault_id = azurerm_key_vault.keyvault.id
    }
  ])
}

locals {
  tls = flatten([
    for tls_key, tls in try(var.vault.secrets.tls_public_key, {}) : {

      tls_key      = tls_key
      algorithm    = tls.algorithm
      name         = tls_key
      rsa_bits     = try(tls.rsa_bits, 2048)
      key_vault_id = azurerm_key_vault.keyvault.id
    }
  ])
}

locals {
  certs = flatten([
    for cert_key, cert in try(var.vault.certs, {}) : {

      cert_key           = cert_key
      name               = cert_key
      issuer             = cert.issuer
      exportable         = cert.exportable
      key_type           = try(cert.key_type, "RSA")
      key_size           = try(cert.key_size, "2048")
      reuse_key          = try(cert.reuse_key, false)
      content_type       = try(cert.content_type, "application/x-pkcs12")
      key_usage          = cert.key_usage
      subject            = cert.subject
      validity_in_months = cert.validity_in_months
      key_vault_id       = azurerm_key_vault.keyvault.id
    }
  ])
}

