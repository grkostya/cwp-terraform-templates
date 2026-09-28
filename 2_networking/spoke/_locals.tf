locals {
  workspace = lower(terraform.workspace)

  workspace_config = {
    dev               = { env = "dev", location_name = "westeurope", location_short = "weu" }
    dev-swedencentral = { env = "dev", location_name = "swedencentral", location_short = "swc" }
    dev-northeurope   = { env = "prd", location_name = "northeurope", location_short = "neu" }
    # uat               = { env = "uat", location_name = "northeurope", location_short = "neu" }
    # prd               = { env = "prd", location_name = "northeurope", location_short = "neu" }
  }

  env            = local.workspace_config[local.workspace].env
  location       = local.workspace_config[local.workspace].location_name
  location_short = local.workspace_config[local.workspace].location_short

  tags            = merge(module.DATA.tags, { Team = "CORE" })
  subscription_id = module.DATA.subscription_id
  tenant_id       = module.DATA.tenant_id
  name_suffix     = module.NAMING.name_suffix

  hub_networking_resource_group_name = "rg-networking-akbp-hub-weu-001"
}
