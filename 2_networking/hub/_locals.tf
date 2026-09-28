locals {
  env  = contains(["hub"], lower(terraform.workspace)) ? lower(terraform.workspace) : "INVALID"
  tags = merge(module.DATA.tags, { Team = "CORE" })
  name_suffix = module.NAMING.name_suffix
  location        = var.location
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  vnet_address_space = var.vnet_address_space
  DateCreated = formatdate("YYYY-MM-DD", time_static.now.rfc3339)
}

