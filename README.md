# Keyvault

 This terraform module simplifies the creation and management of azure key vault resources, providing customizable options for access policies, key and secret management, and auditing, all managed through code.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

## Features

- capability to handle keys, secrets, and certificates.
- includes support for certificate issuers.
- utilization of terratest for robust validation.

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}
```

## Usage: keys

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

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
}
```

## Usage: secrets

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    secrets = {
      random_string = {
        secret1 = {
          length  = 24
          special = false
        }
      }
      tls_keys = {
        tls1 = {
          algorithm = "RSA"
          rsa_bits  = 2048
        }
      }
    }
  }
}
```

## Usage: certs

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

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
```

## Usage: issuers

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    issuers = {
      digicert = {
        org_id        = "12345"
        provider_name = "DigiCert"
        account_id    = "12345"
        password      = "12345"
      }
    }
  }
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
| `naming` | contains naming convention  | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `vault` | contains all key vault config |
| `kv_keys` | contains all keyvault keys |
| `kv_secrets` | contains all keyvault secrets |
| `kv_tls_public_keys` | contains all tls public keys |
| `kv_tls_private_keys` | contains all private tls keys |

## Testing

The github repository utilizes a Makefile to conduct tests to evaluate and validate different configurations of the module. These tests are designed to enhance its stability and reliability.

Before initiating the tests, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) incorporates three distinct test variations. The first one, a local deployment test, is designed for local deployments and allows the overriding of workload and environment values. It includes additional checks and can be initiated using the command ```make test_local```.

The second variation is an extended test. This test performs additional validations and serves as the default test for the module within the github workflow.

The third variation allows for specific deployment tests. By providing a unique test name in the github workflow, it overrides the default extended test, executing the specific deployment test instead.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/az-cn-module-tf-kv/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/az-cn-module-tf-kv/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/key-vault/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/keyvault/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/1f449b5a17448f05ce1cd914f8ed75a0b568d130/specification/keyvault)
