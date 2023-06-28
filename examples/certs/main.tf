provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/cloudnationhq/az-cn-module-tf-rg"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "kv" {
  source = "../../"

  workload    = var.workload
  environment = var.environment

  vault = {
    demo = {
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

      contacts = {
        admin = {
          email = "dennis.kool@cloudnation.nl"
        }
      }
    }
  }
  depends_on = [module.rg]
}
