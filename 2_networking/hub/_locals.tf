locals {
  env  = contains(["hub"], lower(terraform.workspace)) ? lower(terraform.workspace) : "INVALID"
  tags = merge(module.DATA.tags, { Team = "CORE" })

  name_suffix = module.NAMING.name_suffix

  location        = "westeurope"
  subscription_id = module.DATA.subscription_id
  tenant_id       = module.DATA.tenant_id
}
