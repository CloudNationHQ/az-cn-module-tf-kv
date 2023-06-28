# Keyvault

 This terraform module simplifies the creation and management of azure key vault resources, providing customizable options for access policies, key and secret management, and auditing, all managed through code.

The below features and integrations are made available:

- keys, secrets, certificate support
- certificate issuer support
- terratest is used to validate different integrations

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  workload       = var.workload
  environment    = var.environment

  vault = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name

    contacts = {
      admin = {
        email = "dummy@cloudnation.nl"
      }
    }
  }
  depends_on = [module.rg]
}
```

## Usage: keys

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  workload       = var.workload
  environment    = var.environment

  vault = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name

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
```

## Usage: secrets

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  workload       = var.workload
  environment    = var.environment

  vault = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name

    contacts = {
      admin = {
        email = "dummy@cloudnation.nl"
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
  }
  depends_on = [module.rg]
}
```

## Usage: certs

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  workload       = var.workload
  environment    = var.environment

  vault = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name

    contacts = {
      admin = {
        email = "dennis.kool@cloudnation.nl"
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
  }
  depends_on = [module.rg]
}
```

## Usage: issuers

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  workload       = var.workload
  environment    = var.environment

  vault = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name

    contacts = {
      admin = {
        email = "dummy@cloudnation.nl"
      }
    }

    issuers = {
      digicert = {
        org_id        = "12345"
        provider_name = "DigiCert"
        account_id    = "12345"
        password      = "12345"
      }
    }
  }
  depends_on = [module.rg]
}
```

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_key_vault_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [key_vault_certificate_issuer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate_issuer) | resource |
| [azurerm_key_vault_certificate_contacts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate_contacts) | resource |

## Data Sources

| Name | Type |
| :-- | :-- |
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | datasource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `vault` | describes key vault related configuration | object | yes |
| `workload` | contains the workload name used, for naming convention  | string | yes |
| `environment` | contains shortname of the environment used for naming convention  | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `vault` | contains all key vault config |
| `kv_keys` | contains all keyvault keys |

## Testing
This GitHub repository features a [Makefile](./Makefile) tailored for testing various configurations. Each test target corresponds to different example use cases provided within the repository.

Before running these tests, ensure that both Go and Terraform are installed on your system. To execute a specific test, use the following command ```make <test-target>```

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/az-cn-module-tf-kv/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-kv/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/key-vault/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/keyvault/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/1f449b5a17448f05ce1cd914f8ed75a0b568d130/specification/keyvault) az-cn-module-tf-kv
