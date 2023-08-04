# role assignments
resource "azurerm_role_assignment" "current" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

data "azuread_service_principal" "sp" {
  for_each = {for sp in var.vault.role_assignments: sp.display_name => sp if sp.type == "ServicePrincipal"}
  display_name = each.key
}

data "azuread_application" "app" {
  for_each = {for ap in var.vault.role_assignments: ap.display_name => ap if ap.type == "Application"}
  display_name = each.key
}

data "azuread_user" "user" {
  for_each = {for user in var.vault.role_assignments: user.display_name => user if user.type == "User"}
  user_principal_name = each.key
}

resource "azurerm_role_assignment" "other" {
  for_each = try({ for ra in var.vault.role_assignments: ra.display_name => ra}, null)

  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = each.value.role_name
  principal_id         = each.value.type == "ServicePrincipal" ? data.azuread_service_principal.sp[each.key].object_id : each.value.type == "User" ? data.azuread_user.user[each.key].object_id : data.azuread_application.app[each.key].object_id 
}
