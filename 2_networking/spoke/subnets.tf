locals {
  vnet_address_space     = local.address_space[0]
  default_route_table_id = azurerm_route_table.this.id


  # aks_subnets_service_endpoints      = ["Microsoft.Storage"]
  # avd_subnets_service_endpoints      = ["Microsoft.Storage.Global"]
  # func-app_subnets_service_endpoints = ["Microsoft.Storage"]
  # Private-Endpoints_subnets_service_endpoints = ["Microsoft.Storage"]
  # sec-svc_subnets_service_endpoints           = ["Microsoft.Storage"]
  # ado-agents_subnets_service_endpoints        = ["Microsoft.Storage"]


  additional_tags = local.tags


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
      address_prefixes = [cidrsubnet(local.vnet_address_space, 7, 0)] #["10.11.0.0/23"]
      route_table_id   = local.default_route_table_id
      #service_endpoints = local.Private-Endpoints_subnets_service_endpoints
    },

    ## Virtual Machine
    VM = !contains(["dev", ], local.workspace) ? null : {
      address_prefixes = [cidrsubnet(local.vnet_address_space, 8, 2)] #["10.11.2.0/24"]
      route_table_id   = local.default_route_table_id
      #service_endpoints = local.ado-agents_subnets_service_endpoints
    },

    ## Azure Container Apps
    container-apps = !contains(["dev", ], local.workspace) ? null : {
      address_prefixes = [cidrsubnet(local.vnet_address_space, 8, 88)] #["10.11.15.0/24"]
      route_table_id   = local.default_route_table_id
      delegation = {
        name = "ContainerApps"
        service_delegation = {
          name    = "Microsoft.App/environments"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }
    },

    ai-foundry = {
      address_prefixes = [cidrsubnet(local.vnet_address_space, 8, 48)] #["10.11.48.0/24"]
      route_table_id   = local.default_route_table_id
      # service_endpoints = local.aks_subnets_service_endpoints
    },

    ## AKS
    aks = !contains(["dev", ], local.workspace) ? null : {
      address_prefixes = [cidrsubnet(local.vnet_address_space, 4, 2)] #["10.11.32.0/20"]
      route_table_id   = local.default_route_table_id
      # service_endpoints = local.aks_subnets_service_endpoints
    },

    aks-API-server = !contains(["dev", ], local.workspace) ? null : {
      address_prefixes = [cidrsubnet(local.vnet_address_space, 8, 31)] #["10.11.31.0/24"]
      route_table_id   = local.default_route_table_id
      delegation = {
        name = "aks-api-server"
        service_delegation = {
          name    = "Microsoft.ContainerService/managedClusters"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }
    },

    ## Databricks VNet Injection
    ## [assumption] dev-only — extend to uat/prd when Databricks is promoted.
    ## Both subnets require Microsoft.Databricks/workspaces delegation.
    ## NSGs for these subnets are created and owned by the Data_Platform stack
    ## to satisfy azurerm_databricks_workspace.custom_parameters requirements.
    ## /24 chosen for headroom; Azure minimum for Databricks is /26.
    # databricks-public = !contains(["dev", ], local.workspace) ? null : {
    #   address_prefixes = [cidrsubnet(local.vnet_address_space, 8, 3)] #["10.11.3.0/24"]
    #   route_table_id   = local.default_route_table_id
    #   delegation = {
    #     name = "databricks-public"
    #     service_delegation = {
    #       name = "Microsoft.Databricks/workspaces"
    #       actions = [
    #         "Microsoft.Network/virtualNetworks/subnets/join/action",
    #         "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    #         "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
    #       ]
    #     }
    #   }
    # },

    # databricks-private = !contains(["dev", ], local.workspace) ? null : {
    #   address_prefixes = [cidrsubnet(local.vnet_address_space, 8, 4)] #["10.11.4.0/24"]
    #   route_table_id   = local.default_route_table_id
    #   delegation = {
    #     name = "databricks-private"
    #     service_delegation = {
    #       name = "Microsoft.Databricks/workspaces"
    #       actions = [
    #         "Microsoft.Network/virtualNetworks/subnets/join/action",
    #         "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    #         "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
    #       ]
    #     }
    #   }
    # },

    ## PostgreSQL Flexible Server
    psql = !contains(["dev", ], local.workspace) ? null : {
      address_prefixes = [cidrsubnet(local.vnet_address_space, 8, 5)] #["10.11.5.0/24"]
      route_table_id   = local.default_route_table_id
      nsg_rules        = local.psql_nsg_rules
      delegation = {
        name = "psql_flexibleservers"
        service_delegation = {
          name    = "Microsoft.DBforPostgreSQL/flexibleServers"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", ]
        }
      }
      service_endpoints = ["Microsoft.Storage"]
    },

    ## Managed DevOps Pool
    # manageddevopspool = !contains(["dev-westeurope", ], local.workspace) ? null : {
    #   address_prefixes = [cidrsubnet(local.vnet_address_space, 8, 6)] #["10.11.6.0/24"]
    #   route_table_id   = local.default_route_table_id
    #   delegation = {
    #     name = "manageddevopspool"
    #     service_delegation = {
    #       name    = "Microsoft.DevOpsInfrastructure/pools"
    #       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    #     }
    #   }
    # },

    ## API Management
    # apim = !contains(["dev",], local.workspace) ? null : {
    #   address_prefixes  = [cidrsubnet(local.vnet_address_space, 5, 19)] #["10.11.18.96/27"] #27
    #   route_table_id    = local.default_route_table_id
    #   nsg_rules         = local.apim_nsg_rules
    #   service_endpoints = local.apim_subnets_service_endpoints
    # },

    ## Aapplication Gateway for UI
    # appgw = !contains(["dev",], local.workspace) ? null : {
    #   address_prefixes = [cidrsubnet(local.vnet_address_space, 5, 18)] #["10.11.18.64/27"] #27
    #   route_table_id   = local.default_route_table_id
    #   nsg_rules        = local.agw_nsg_rules
    #   delegation = {
    #     name = "applicationGateways"
    #     service_delegation = {
    #       name    = "Microsoft.Network/applicationGateways"
    #       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", ]
    #     }
    #   }
    #   service_endpoints = local.agw_subnets_service_endpoints
    # },

    ## ADO Self-Hosted Agents
    # ado-agents = !contains(["dev",], local.workspace) ? null : {
    #   address_prefixes  = [cidrsubnet(local.vnet_address_space, 6, 1)] #["10.11.16.16/28"] #11
    #   route_table_id    = local.default_route_table_id
    #   service_endpoints = local.ado-agents_subnets_service_endpoints
    # },

    ## Fucntion App
    # func-app = !contains(["dev",], local.workspace) ? null : {
    #   address_prefixes = [cidrsubnet(local.vnet_address_space, 6, 40)] #["10.11.18.128/28"] #11
    #   route_table_id   = local.default_route_table_id
    #   delegation = {
    #     name = "FunctionApp"
    #     service_delegation = {
    #       name    = "Microsoft.Web/serverFarms"
    #       actions = ["Microsoft.Network/virtualNetworks/subnets/action", ]
    #     }
    #   }
    #   service_endpoints = local.func-app_subnets_service_endpoints
    # },

    ## Security Services
    # sec-svc = !contains(["dev",], local.workspace) ? null : {
    #   address_prefixes  = [cidrsubnet(local.vnet_address_space, 5, 21)] #["10.11.18.160/27"]
    #   route_table_id    = local.default_route_table_id
    #   service_endpoints = local.sec-svc_subnets_service_endpoints
    # },

    # ## AVD
    # avd = !contains(["dev",], local.workspace) ? null :  {
    #   address_prefixes  = [cidrsubnet(local.vnet_address_space, 4, 8)] #["10.11.18.0/26"]
    #   route_table_id    = local.default_route_table_id
    #   service_endpoints = local.avd_subnets_service_endpoints
    # },

    ## ML Workspaces
    # ML = local.env !contains(["dev",], local.workspace) ? null : {
    #   address_prefixes  = [cidrsubnet(local.vnet_address_space, 8, 65)] #["10.11.65.0/24"]
    #   route_table_id    = local.default_route_table_id
    #   service_endpoints = [
    #     "Microsoft.KeyVault",
    #     "Microsoft.Storage",
    #     "Microsoft.AzureCosmosDB",
    #     "Microsoft.CognitiveServices"
    #   ]
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
