# Azure Key Vault & Storage (Terraform)

Terraform that deploys one Key Vault and two Storage Accounts in Azure using a shared module.

## What gets created

- **Resource group** – one per env (name includes `env`).
- **Key Vault** – Canada East, public network access off, 7-day soft delete. Tagged with `env`.
- **Storage (LRS)** – Canada Central, LRS, blob public access disabled. Tagged with `env`.
- **Storage (RA-GRS)** – Canada East, RA-GRS, blob public access enabled. Tagged with `env`.

All resources use the `env` tag with one of: `dev`, `qa`, `stg`, `prd`.

## Prereqs

- Terraform >= 1.0.
- Azure CLI logged in: `az login`.
- Permissions to create resource groups, Key Vaults, and Storage Accounts in the subscription.

## Quick run

```bash
cd terraform/azure-keyvault-storage
cp backend.tf.example backend.tf   # edit with your state storage details
terraform init
terraform plan
terraform apply
```

Use a different env:

```bash
terraform apply -var="env=qa"
# or: env=stg, env=prd
```

## Inputs

| Variable               | Default        | Description                         |
|------------------------|----------------|-------------------------------------|
| `env`                  | `dev`          | Environment: dev, qa, stg, prd     |
| `project_name`         | `tfassignment` | Used in the resource group name    |
| `location_kv`          | `canadaeast`   | Region for Key Vault                |
| `location_storage_lrs` | `canadacentral`| Region for LRS storage              |
| `location_storage_ragrs`| `canadaeast`  | Region for RA-GRS storage           |

## Outputs

- `resource_group_name`
- `key_vault_id`, `key_vault_name`
- `storage_lrs_name`, `storage_ragrs_name`

## Module

`modules/keyvault-storage` – reusable module that can create either a Key Vault or a Storage Account (or both in separate calls). Root `main.tf` calls it once for the vault and once per storage account with the right regions and options.

Key Vault with public access disabled is only reachable via Private Endpoint (VNet, private endpoint, VPN/peering), or temporarily re-enable public access for testing.

## Cleanup

```bash
terraform destroy -var="env=dev"
```
