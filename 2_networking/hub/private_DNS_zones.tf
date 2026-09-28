locals {
  private_DNS_zones = toset(compact([
    ## Key Vault
    "privatelink.vaultcore.azure.net",

    ## AKS
    "privatelink.${local.location}.azmk8s.io",

    ## Storage Account
    "privatelink.blob.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.file.core.windows.net",
    # "privatelink.web.core.windows.net",
    # "privatelink.queue.core.windows.net",
    # "privatelink.table.core.windows.net",

    ## PostgreSQL
    "privatelink.postgres.database.azure.com",

    ## CosmosDB
    #"privatelink.documents.azure.com",
    #"privatelink.mongo.cosmos.azure.com",

    ## Container Registry
    "privatelink.azurecr.io",

    ## ML Workspace
    # local.env == "dev" ? "privatelink.notebooks.azure.net" : null,
    "privatelink.api.azureml.ms",
    "privatelink.notebooks.azure.net",

    ## Purview
    # "privatelink.purview.azure.com",

    ## Monitor
    "privatelink.monitor.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.${local.location}.prometheus.monitor.azure.com", ## Prometheus
    "privatelink.grafana.azure.com",                              ## Grafana

    ## Azure AI services
    "privatelink.cognitiveservices.azure.com",
    "privatelink.openai.azure.com",
    "privatelink.services.ai.azure.com",
    "privatelink.search.windows.net", ## AI Search

    ## WEB
    # "privatelink.azurewebsites.net",
    # "scm.azurewebsites.net",

    ## QUEUE
    #"privatelink.servicebus.windows.net",

    ## APIM
    # "azure-api.net",
    # "portal.azure-api.net",
    # "developer.azure-api.net",
    # "management.azure-api.net",
    # "scm.azure-api.net",

    ## Redis Cache
    # "privatelink.redis.azure.net",
    # "privatelink.redis.cache.windows.net",

    ## Backup (Recovery Service Vault)
    # "privatelink.uan.backup.windowsazure.com",

    ## Databricks
    "privatelink.azuredatabricks.net",
  ]))
}




resource "azurerm_private_dns_zone" "this" {
  for_each = local.private_DNS_zones

  name                = each.value
  resource_group_name = azurerm_resource_group.this.name
  tags                = merge(local.tags, { DateCreated = local.DateCreated })
}


resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = local.private_DNS_zones

  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  name                  = azurerm_virtual_network.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
  resource_group_name   = azurerm_resource_group.this.name
  tags                  = merge(local.tags, { DateCreated = local.DateCreated })
}
