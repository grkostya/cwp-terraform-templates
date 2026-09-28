# Networking / SPOKE

Terraform stack that provisions the SPOKE virtual network and associated networking resources for each environment.

## Resources

| File | Resources |
|------|-----------|
| `main.tf` | Resource Group, Virtual Network |
| `UDR.tf` | Route Table |
| `subnets.tf` | Subnets (via `subnets` module) |
| `AMPLS.tf` | Azure Monitor Private Link Scope + Private Endpoint |
| `private_DNS_zones.tf` | Private DNS Zone data lookups + VNet links |

## Workspaces

Workspace is the sole environment selector — no `.tfvars` files are used.

| Workspace | `env` | Location | VNet address space |
|-----------|-------|----------|--------------------|
| `dev` | `dev` | North Europe (`neu`) | `10.11.0.0/16` |
| `uat` | `uat` | North Europe (`neu`) | `10.12.0.0/16` |
| `prd` | `prd` | North Europe (`neu`) | `10.13.0.0/16` |
| `dev-swedencentral` | `dev` | Sweden Central (`swc`) | `10.111.0.0/16` |

## Subnets

Address expressions are relative to the workspace VNet (`local.vnet_address_space`).

| Key | `cidrsubnet` | Example (`dev`) | Delegation | Env |
|-----|-------------|-----------------|------------|-----|
| `Private-Endpoints` | `, 7, 0` | `10.11.0.0/23` | — | all |
| `VM` | `, 8, 2` | `10.11.2.0/24` | — | all |
| `container-apps` | `, 8, 88` | `10.11.88.0/24` | `Microsoft.App/environments` | all |
| `aks` | `, 4, 8` | `10.11.128.0/20` | — | all |
| `aks-API-server` | `, 8, 126` | `10.11.126.0/24` | `Microsoft.ContainerService/managedClusters` | all |
| `ML` | `, 8, 16` | `10.11.16.0/24` | — | `dev` only |

All subnets are linked to the default Route Table at creation time.

## Private DNS Zones

Zones are looked up from the HUB resource group (`rg-networking-nrgi-hub-neu-001`) and linked to the SPOKE VNet:

- `privatelink.vaultcore.azure.net`
- `privatelink.blob.core.windows.net`
- `privatelink.dfs.core.windows.net`
- `privatelink.file.core.windows.net`
- `privatelink.azurecr.io`
- `privatelink.api.azureml.ms`
- `privatelink.notebooks.azure.net`
- `privatelink.monitor.azure.com`
- `privatelink.oms.opinsights.azure.com`
- `privatelink.ods.opinsights.azure.com`
- `privatelink.agentsvc.azure-automation.net`

## Remote State

| Setting | Value |
|---------|-------|
| Storage account | `stterraformnrgineu001` |
| Resource group | `rg-terraform-nrgi-neu-001` |
| Container | `networking` |
| Key | `terraform.tfstate-NETWORKING-SPOKE.` |
| Auth | Azure AD (no access keys) |

## Usage

```bash
az login

terraform init

# Deploy to a specific environment
terraform workspace select dev
terraform plan
terraform apply

# Deploy to Sweden Central dev
terraform workspace select dev-swedencentral
terraform plan
terraform apply
```

## Requirements

| Tool | Version |
|------|---------|
| Terraform | `>= 1.9.8` |
| azurerm provider | `>= 4.66.0` |
| time provider | `>= 0.13.0` |
