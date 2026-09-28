locals {
  psql_nsg_rules = {
    ## Inbound rules
    "Allow-PostgreSQL-Inbound" = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["5432", "6432"]
      source_address_prefix      = local.vnet_address_space ## AKS
      destination_address_prefix = "*"
      description                = "https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-networking-private#virtual-network-concepts"
    },
    "Allow-AzureLoadBalancer-Inbound" = {
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    },
    "Deny-Rest-Inbound" = {
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    ## Outbound rules
    "Allow-Default-Subnet-Outbound" = {
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = local.vnet_address_space ## Private-Endpoints
    },
    "Allow-AzureStorage-Logs-Outbound" = {
      priority                   = 120
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Storage.UAENorth"
      description                = "https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-networking-private#virtual-network-concepts"
    }
    "Allow-EntraID-Outbound" = {
      priority                   = 130
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureActiveDirectory"
    }
    "Deny-Rest-Outbound" = {
      priority                   = 1000
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
