# locals {
#   vpn_client_address_pool = "172.16.0.0/24"
#   vpn_client_protocols    = ["OpenVPN"]
# }




# ###########################################################################
# ## GatewaySubnet — Azure requires this exact name; no UDR or NSG allowed
# resource "azurerm_subnet" "GatewaySubnet" {
#   name                 = "GatewaySubnet"
#   resource_group_name  = azurerm_resource_group.this.name
#   virtual_network_name = azurerm_virtual_network.this.name
#   address_prefixes     = [cidrsubnet(local.vnet_address_space[0], 8, 254)] ## 10.10.254.0/24
# }




# ###########################################################################
# ## VPN Gateway
# resource "azurerm_public_ip" "VPN_Gateway" {
#   name                = "pip-vpng-${local.name_suffix}"
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   zones               = ["1", "2", "3"]
#   tags                = merge(local.tags, { DateCreated = local.DateCreated })
# }


# resource "azurerm_virtual_network_gateway" "this" {
#   name                = "vpng-${local.name_suffix}"
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name
#   tags                = merge(local.tags, { DateCreated = local.DateCreated })

#   type       = "Vpn"
#   vpn_type   = "RouteBased"
#   sku        = "VpnGw2AZ" ## Zone-redundant; use VpnGw1 for lower cost (non-HA)
#   generation = "Generation2"

#   active_active = false
#   # enable_bgp    = false

#   ip_configuration {
#     name                          = "vnetGatewayConfig"
#     public_ip_address_id          = azurerm_public_ip.VPN_Gateway.id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.GatewaySubnet.id
#   }

#   vpn_client_configuration {
#     address_space        = [local.vpn_client_address_pool]
#     vpn_client_protocols = local.vpn_client_protocols

#     ## Certificate authentication — replace with actual root certificate public data (base64 DER, no PEM headers)
#     # root_certificate {
#     #   name             = "P2SRootCert"
#     #   public_cert_data = "" ## TODO: insert base64-encoded root certificate DER
#     # }

#     ## Azure AD (Entra ID) authentication — uncomment and remove root_certificate block to switch auth method
#     ## Requires tenant_id = module.DATA.tenant_id in _locals.tf
#     aad_tenant   = "https://login.microsoftonline.com/${local.tenant_id}/"
#     aad_audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4" ## Azure VPN Client well-known app ID
#     aad_issuer   = "https://sts.windows.net/${local.tenant_id}/"
#   }

#   custom_route {
#     address_prefixes = [
#         "10.11.0.0/16",
#         "10.111.0.0/16",
#       ]
#   }
# }




# # ###########################################################################
# # ## Diagnostic Settings
# # resource "azurerm_monitor_diagnostic_setting" "VPN_Gateway" {
# #   name                       = "diag-${azurerm_virtual_network_gateway.this.name}"
# #   target_resource_id         = azurerm_virtual_network_gateway.this.id
# #   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this.id
# #
# #   enabled_log { category = "GatewayDiagnosticLog" }
# #   enabled_log { category = "TunnelDiagnosticLog" }
# #   enabled_log { category = "RouteDiagnosticLog" }
# #   enabled_log { category = "IKEDiagnosticLog" }
#   # enabled_log { category = "P2SDiagnosticLog" }
# #
# #   metric {
# #     category = "AllMetrics"
# #     enabled  = true
# #   }
# # }
