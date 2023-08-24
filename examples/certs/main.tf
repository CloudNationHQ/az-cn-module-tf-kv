provider "azurerm" {
  features {}
}

module "naming" {
  source = "github.com/cloudnationhq/az-cn-module-tf-naming"

  suffix = ["demo", "dev"]
}

module "rg" {
  source = "github.com/cloudnationhq/az-cn-module-tf-rg"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "kv" {
  source = "../../"

  naming = local.naming

  vault = {
    demo = {
      name          = module.naming.key_vault.name_unique
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name

      certs = {
        example = {
          issuer             = "Self"
          subject            = "CN=app1.demo.org"
          validity_in_months = 12
          exportable         = true
          key_usage = [
            "cRLSign", "dataEncipherment",
            "digitalSignature", "keyAgreement",
            "keyCertSign", "keyEncipherment"
          ]
        }
      }
    }
  }
}
