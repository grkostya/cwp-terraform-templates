# module "BASTION" {
#   source = "git::https://dev.azure.com/AKBP/HAGS/_git/terraform-modules//modules/bastion?ref=v1.0.0"

#   resource_group          = azurerm_resource_group.this
#   name                    = module.NAMING.networking.bastion_host.name
#   sku                     = "Standard"
#   virtual_network_name    = azurerm_virtual_network.this.name
#   subnet_address_prefixes = [cidrsubnet(local.vnet_address_space[0], 8, 0)] ## xxx.xxx.0.0./16 -> xxx.xxx.0.0/24
#   tunneling_enabled       = true
# }




# ###########################################################################
# ## NSG
# locals {
#   bastion_nsg_rules = {
#     "Allow-EPAM-VPN-Gateways-Inbound" = {
#       priority                   = 100
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = "443"
#       source_address_prefixes    = ["195.56.119.209", "195.56.119.212", "204.153.55.4", "203.170.48.2", "85.223.209.18", "174.128.60.160", "174.128.60.162"] ## EPAM VPN Gateways
#       destination_address_prefix = "*"
#     }
#     "Allow-GatewayManager-Inbound" = {
#       priority                   = 110
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = "443"
#       source_address_prefix      = "GatewayManager"
#       destination_address_prefix = "*"
#     }
#     "Allow-AzureLoadBalancer-Inbound" = {
#       priority                   = 120
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = "443"
#       source_address_prefix      = "AzureLoadBalancer"
#       destination_address_prefix = "*"
#     }
#     "Allow-BastionHost-Communication" = {
#       priority                   = 130
#       direction                  = "Inbound"
#       access                     = "Allow"
#       source_port_range          = "*"
#       destination_port_ranges    = ["8080", "5701"]
#       source_address_prefix      = "VirtualNetwork"
#       destination_address_prefix = "VirtualNetwork"
#     }
#     "Deny-Rest-Inbound" = {
#       priority                   = 1000
#       direction                  = "Inbound"
#       access                     = "Deny"
#       source_port_range          = "*"
#       destination_port_range     = "*"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     }
#     "Allow-Ssh-Rdp-Outbound" = {
#       priority                   = 100
#       direction                  = "Outbound"
#       access                     = "Allow"
#       source_port_range          = "*"
#       destination_port_ranges    = ["22", "3389"]
#       source_address_prefix      = "*"
#       destination_address_prefix = "VirtualNetwork"
#     }
#     "Allow-AzureCloud-Outbound" = {
#       priority                   = 110
#       direction                  = "Outbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = "443"
#       source_address_prefix      = "*"
#       destination_address_prefix = "AzureCloud"
#     }
#     "Allow-Bastion-Communication" = {
#       priority                   = 120
#       direction                  = "Outbound"
#       access                     = "Allow"
#       source_port_range          = "*"
#       destination_port_ranges    = ["8080", "5701"]
#       source_address_prefix      = "VirtualNetwork"
#       destination_address_prefix = "VirtualNetwork"
#     }
#     "Allow-Http-Outbound" = {
#       priority                   = 130
#       direction                  = "Outbound"
#       access                     = "Allow"
#       source_port_range          = "*"
#       destination_port_range     = "80"
#       source_address_prefix      = "*"
#       destination_address_prefix = "Internet"
#     }
#     "Deny-Rest-Outbound" = {
#       priority                   = 1000
#       direction                  = "Outbound"
#       access                     = "Deny"
#       source_port_range          = "*"
#       destination_port_range     = "*"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     }
#   }
# }




# resource "azurerm_subnet_network_security_group_association" "Bastion" {
#   subnet_id                 = module.BASTION.subnet_id
#   network_security_group_id = azurerm_network_security_group.Bastion.id

#   depends_on = [azurerm_network_security_rule.Bastion]
# }


# resource "azurerm_network_security_group" "Bastion" {
#   name                = "nsg-${module.BASTION.name}"
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name
#   tags                = azurerm_resource_group.this.tags
# }


# resource "azurerm_network_security_rule" "Bastion" {
#   for_each = local.bastion_nsg_rules

#   name                         = each.key
#   priority                     = each.value.priority
#   direction                    = each.value.direction
#   access                       = each.value.access
#   protocol                     = try(each.value.protocol, "*")
#   source_port_range            = try(each.value.source_port_range, null)
#   source_port_ranges           = try(each.value.source_port_ranges, null)
#   destination_port_range       = try(each.value.destination_port_range, null)
#   destination_port_ranges      = try(each.value.destination_port_ranges, null)
#   source_address_prefix        = try(each.value.source_address_prefix, null)
#   source_address_prefixes      = try(each.value.source_address_prefixes, null)
#   destination_address_prefix   = try(each.value.destination_address_prefix, null)
#   destination_address_prefixes = try(each.value.destination_address_prefixes, null)
#   description                  = try(each.value.description, null)
#   resource_group_name          = azurerm_resource_group.this.name
#   network_security_group_name  = azurerm_network_security_group.Bastion.name
# }
