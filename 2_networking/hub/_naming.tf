module "NAMING" {
  source            = "git::https://dev.azure.com/AKBP/HAGS/_git/terraform-modules//modules/naming?ref=v1.0.0"
  application_code  = "networking"
  subscription_code = var.subscription_code
  location          = { name = local.location, short_name = var.location_short }
  environment       = local.env
}

