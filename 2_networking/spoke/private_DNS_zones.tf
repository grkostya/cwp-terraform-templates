locals {
  private_DNS_zones = toset(compact([
    ## AKS
    contains(["dev", ], local.workspace) ? "privatelink.${local.location}.azmk8s.io" : null,

    ## Key Vault
    "privatelink.vaultcore.azure.net",

    ## Storage Account
    "privatelink.blob.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.file.core.windows.net",

    ## PostgreSQL
    "privatelink.postgres.database.azure.com",

    ## Container Registry
    "privatelink.azurecr.io",

    ## ML Workspace
    "privatelink.api.azureml.ms",
    "privatelink.notebooks.azure.net",

    ## Monitor
    "privatelink.monitor.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.agentsvc.azure-automation.net",
    contains(["dev", ], local.workspace) ? "privatelink.${local.location}.prometheus.monitor.azure.com" : null, ## Prometheus
    contains(["dev", ], local.workspace) ? "privatelink.grafana.azure.com" : null,                              ## Grafana

    ## Databricks
    "privatelink.azuredatabricks.net",
  ]))
}



data "azurerm_private_dns_zone" "this" {
  for_each = local.private_DNS_zones

  name                = each.value
  resource_group_name = local.hub_networking_resource_group_name
}


resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = local.private_DNS_zones

  private_dns_zone_name = data.azurerm_private_dns_zone.this[each.key].name
  name                  = azurerm_virtual_network.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
  resource_group_name   = local.hub_networking_resource_group_name
  tags                  = merge(local.tags, { DateCreated = local.DateCreated })
}
