locals {
  additional_tags        = local.tags
  default_route_table_id = azurerm_route_table.this.id
  subnets_generic = {
    Private-Endpoints = {
      address_prefixes = [cidrsubnet(local.vnet_address_space[0], 7, 1)] #["10.10.2.0/23"]
      route_table_id   = local.default_route_table_id
    },
  }
  ## Stripped object
  subnets = { for k, v in local.subnets_generic : k => v if v != null }
}

module "Subnets" {
  source = "git::https://dev.azure.com/AKBP/HAGS/_git/terraform-modules//modules/subnets?ref=v1.0.0"
  for_each = local.subnets
  vnet             = azurerm_virtual_network.this
  subnet_name      = "snet-${each.key}-${local.name_suffix}"
  address_prefixes = each.value.address_prefixes
  use_udr           = true
  route_table_id    = try(each.value.route_table_id, null)
  service_endpoints = try(each.value.service_endpoints, [])
  nsg_rules         = try(each.value.nsg_rules, {})
  delegation        = try(each.value.delegation, null)
  additional_tags = local.additional_tags
}