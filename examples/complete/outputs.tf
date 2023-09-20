output "vault" {
  value     = module.kv.vault
  sensitive = true
}

output "subscriptionId" {
  value = module.kv.subscriptionId
}
