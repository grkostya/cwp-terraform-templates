locals {
  additional_tags        = local.tags
  default_route_table_id = azurerm_route_table.this.id

  ### List of subnets with conditions based on the env value
  subnets_generic = {
    ## Sample
    # subnet_name_code = {
    #   address_prefixes  = [cidrsubnet(local.vnet_address_space, 8, 1)]
    #   service_endpoints = local.aks_subnets_service_endpoints
    #   route_table_id    = data.azurerm_route_table.default.id
    #   delegation = {
    #     name = "fs"
    #     service_delegation = {
    #       name    = "Microsoft.DBforPostgreSQL/flexibleServers"
    #       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", ] ## (OPTIONAL)
    #     }
    #   }
    #   nsg_rules = {
    #     rule_name = {
    #       priority                     = "1000"
    #       direction                    = "Inbound" / "Outbound"
    #       access                       = "Allow" / "Deny"
    #       protocol                     = "Tcp" / "Udp" / "*" / "Icmp" / "Esp" / "Ah"
    #       source_port_range            = "443" / "0-65535" / "*" / null
    #       source_port_ranges           = ["80", "443", "8000-9000"] / null
    #       destination_port_range       = "443" / "0-65535" / "*" / null
    #       destination_port_ranges      = ["80", "443", "8000-9000"] / null
    #       source_address_prefix        = "0.0.0.0/0" / "*" / "VirtualNetwork" / "AzureLoadBalancer" / "Internet"
    #       source_address_prefixes      = ["0.0.0.0/0", ]
    #       destination_address_prefix   = "0.0.0.0/0" / "*" / "VirtualNetwork" / "AzureLoadBalancer" / "Internet"
    #       destination_address_prefixes = ["0.0.0.0/0", ]
    #       description                  = "(Optional) A description for this rule. Restricted to 140 characters."
    #     }
    #   }
    # },

    Private-Endpoints = {
      address_prefixes = [cidrsubnet(local.vnet_address_space[0], 7, 1)] #["10.10.2.0/23"]
      route_table_id   = local.default_route_table_id
      #service_endpoints = local.Private-Endpoints_subnets_service_endpoints
    },

    # ## AVD
    # avd = local.env != "dev" ? null : {
    #   address_prefixes  = [cidrsubnet(local.vnet_address_space, 4, 8)] #["10.212.18.0/26"]
    #   route_table_id    = local.default_route_table_id
    #   service_endpoints = local.avd_subnets_service_endpoints
    # },
  }


  ## Stripped object
  subnets = { for k, v in local.subnets_generic : k => v if v != null }
}




## Use Bicep to create subnets
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


# # Disallowed by policy. UDR should be linked to a subnet during creation
# resource "azurerm_subnet_route_table_association" "this" {
#   for_each = local.subnets

#   subnet_id      = module.Subnets[each.key].id
#   route_table_id = azurerm_route_table.this.id
# }
