data "azurerm_client_config" "current" {}
module "DATA" {
  source = "git::https://dev.azure.com/AKBP/HAGS/_git/terraform-modules//modules/data_AKBP-HAGS?ref=main"
}
