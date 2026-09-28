resource "azurerm_monitor_private_link_scope" "this" {
  name                = module.NAMING.custom.monitor_private_link_scope.name
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags

  ingestion_access_mode = "PrivateOnly" ## "Open"
  query_access_mode     = "PrivateOnly" ## "Open"
}




module "Private_Endpoint_AMPLS" {
  source = "git::https://dev.azure.com/AKBP/HAGS/_git/terraform-modules//modules/private_endpoint?ref=v1.1.1"

  resource_group              = azurerm_resource_group.this
  private_connection_resource = azurerm_monitor_private_link_scope.this
  subresource_names           = ["azuremonitor"]
  subnet_id                   = module.Subnets["Private-Endpoints"].id
  private_dns_zone_ids = [
    data.azurerm_private_dns_zone.this["privatelink.monitor.azure.com"].id,
    data.azurerm_private_dns_zone.this["privatelink.oms.opinsights.azure.com"].id,
    data.azurerm_private_dns_zone.this["privatelink.ods.opinsights.azure.com"].id,
    data.azurerm_private_dns_zone.this["privatelink.agentsvc.azure-automation.net"].id,
    data.azurerm_private_dns_zone.this["privatelink.blob.core.windows.net"].id
  ]
  tags = local.tags
}
