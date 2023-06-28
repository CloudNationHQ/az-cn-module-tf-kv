output "vault" {
  value = azurerm_key_vault.keyvault
}

output "kv_keys" {
  value = azurerm_key_vault_key.kv_keys
}

output "random_string" {
  value = azurerm_key_vault_secret.secret
}

output "tls_public_key" {
  value = azurerm_key_vault_secret.tls_secret
}

# output "merged_ids" {
#   value = values(azurerm_key_vault.keyvault)[*].id
# }
