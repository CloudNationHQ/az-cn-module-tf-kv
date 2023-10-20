# Keyvault

 This terraform module simplifies the creation and management of azure key vault resources, providing customizable options for access policies, key and secret management, and auditing, all managed through code.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Features

- capability to handle keys, secrets, and certificates.
- includes support for certificate issuers.
- utilization of terratest for robust validation.
- supports key rotation policy for enhanced security and compliance.
- integrates seamlessly with private endpoint capabilities for direct and secure connectivity.

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
      DigiCert = { org_id = "12345", account_id = "12345", password = "12345" }
    }
  }
}
```

## Usage: private endpoint

```hcl
module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    private_endpoint = {
      name         = module.naming.private_endpoint.name
      dns_zones    = [module.private_dns.zone.id]
      subnet       = module.network.subnets.sn1.id
      subresources = ["vault"]
    }
  }
}
```

To enable private link, the below private dns submodule can be employed:

```hcl
module "private_dns" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv/modules/private-dns"

  providers = {
    azurerm = azurerm.connectivity
  }

  zone = {
    name          = "privatelink.vaultcore.azure.net"
    resourcegroup = "rg-dns-shared-001"
    vnet          = module.network.vnet.id
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
| [azurerm_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Data Sources

| Name | Type |
| :-- | :-- |
| [azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | datasource |
| [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | datasource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `vault` | describes key vault related configuration | object | yes |
| `naming` | contains naming convention  | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `vault` | contains all key vault config |
| `keys` | contains all keyvault keys |
| `secrets` | contains all keyvault secrets |
| `tls_public_keys` | contains all tls public keys |
| `tls_private_keys` | contains all private tls keys |

## Testing

As a prerequirement, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) includes two distinct variations of tests. The first one is designed to deploy different usage scenarios of the module. These tests are executed by specifying the TF_PATH environment variable, which determines the different usages located in the example directory.

To execute this test, input the command ```make test TF_PATH=simple```, substituting simple with the specific usage you wish to test.

The second variation is known as a extended test. This one performs additional checks and can be executed without specifying any parameters, using the command ```make test_extended```.

Both are designed to be executed locally and are also integrated into the github workflow.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory

To integrate seamlessly with the enterprise scale's centrally managed private dns zones within a connectivity subscription, you can employ the private dns submodule, designed to work effectively with an aliased provider.

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/az-cn-module-tf-kv/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/az-cn-module-tf-kv/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/key-vault/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/keyvault/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/1f449b5a17448f05ce1cd914f8ed75a0b568d130/specification/keyvault)
