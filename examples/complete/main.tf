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

    keys = {
      demo = {
        key_type = "RSA"
        key_size = 2048
        key_opts = [
          "decrypt", "encrypt", "sign",
          "unwrapKey", "verify", "wrapKey"
        ]
        rotation_policy = {
          expire_after         = "P90D"
          notify_before_expiry = "P30D"
          automatic = {
            time_after_creation = "P83D"
            time_before_expiry  = "P30D"
          }
        }
      }
    }

    secrets = {
      random_string = {
        example1 = {
          length  = 24
          special = false
        }
      }
      tls_public_key = {
        example2 = {
          algorithm = "RSA"
          rsa_bits  = 2048
        }
      }
    }

    issuers = {
      digicert = {
        org_id     = "12345"
        provider   = "DigiCert"
        account_id = "12345"
        password   = "12345"
      }
    }

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
        email = "dummy@cloudnation.nl"
      }
    }
  }
  depends_on = [module.rg]
}
