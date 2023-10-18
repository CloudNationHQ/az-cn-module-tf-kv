locals {
  vaults = {
    kv1 = {
      name          = join("-", [module.naming.key_vault.name_unique, "001"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
    },
    kv2 = {
      name          = join("-", [module.naming.key_vault.name_unique, "002"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
    }
  }
}
