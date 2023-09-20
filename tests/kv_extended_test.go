package main

import (
	"context"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/keyvault/armkeyvault"
	"github.com/cloudnationhq/az-cn-module-tf-kv/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type VaultDetails struct {
	ResourceGroupName string
	Name              string
}

type ClientSetup struct {
	SubscriptionID string
	VaultClient *armkeyvault.VaultsClient
}

func (details *VaultDetails) GetVault(t *testing.T, client *armkeyvault.VaultsClient) *armkeyvault.Vault {
	resp, err := client.Get(context.Background(), details.ResourceGroupName, details.Name, nil)
	require.NoError(t, err, "Failed to get vault")
	return &resp.Vault
}

func (setup *ClientSetup) InitializeVaultClient(t *testing.T, cred *azidentity.DefaultAzureCredential) {
	var err error
	setup.VaultClient, err = armkeyvault.NewVaultsClient(setup.SubscriptionID, cred, nil)
	require.NoError(t, err, "Failed to create vault client")
}

func TestVault(t *testing.T) {
	t.Run("VerifyVault", func(t *testing.T) {
		t.Parallel()

		cred, err := azidentity.NewDefaultAzureCredential(nil)
		require.NoError(t, err, "Failed to create credential")

		tfOpts := shared.GetTerraformOptions("../examples/complete")
		defer shared.Cleanup(t, tfOpts)
		terraform.InitAndApply(t, tfOpts)

		vaultMap := terraform.OutputMap(t, tfOpts, "vault")
		subscriptionID := terraform.Output(t, tfOpts, "subscriptionId")

		vaultDetails := &VaultDetails{
			ResourceGroupName: vaultMap["resource_group_name"],
			Name:              vaultMap["name"],
		}

		ClientSetup := &ClientSetup{SubscriptionID: subscriptionID}
		ClientSetup.InitializeVaultClient(t, cred)
		vault := vaultDetails.GetVault(t, ClientSetup.VaultClient)

		t.Run("VerifyVault", func(t *testing.T) {
			verifyVault(t, vaultDetails, vault)
		})
	})
}

func verifyVault(t *testing.T, details *VaultDetails, vault *armkeyvault.Vault) {
	t.Helper()

	require.Equal(
		t,
		details.Name,
		*vault.Name,
		"Vault name does not match expected value",
	)

	require.Equal(
		t,
		"Succeeded",
		string(*vault.Properties.ProvisioningState),
		"Vault provisioning state is not Succeeded",
	)

	require.True(
		t,
		strings.HasPrefix(details.Name, "kv"),
		"Vault name does not start with the right abbreviation",
	)
}
