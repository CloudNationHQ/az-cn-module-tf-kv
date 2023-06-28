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
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    contacts = {
      admin = {
        email = "dummy@cloudnation.nl"
      }
    }

    keys = {
      demo = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey"
        ]

        policy = {
          rotation = {
            expire_after         = "P90D"
            notify_before_expiry = "P30D"
            automatic = {
              time_after_creation = "P83D"
              time_before_expiry  = "P30D"
            }
          }
        }
      }
    }
  }
  depends_on = [module.rg]
}

