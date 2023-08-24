output "vault" {
  value = azurerm_key_vault.keyvault
}

output "kv_keys" {
  value = azurerm_key_vault_key.kv_keys
}

output "kv_secrets" {
  value = azurerm_key_vault_secret.secret
}

output "tls_public_keys" {
  value = azurerm_key_vault_secret.tls_public_key_secret
}

output "tls_private_keys" {
  value = azurerm_key_vault_secret.tls_private_key_secret
}
