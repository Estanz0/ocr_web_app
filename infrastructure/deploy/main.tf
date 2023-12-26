###########################
# Existing Infrastructure #
###########################

# Subscription
data "azurerm_subscription" "default" {}



############################
# Terraform Infrastructure #
############################

# Resource Group
resource "azurerm_resource_group" "default" {
    name     = "rg-ocr-${terraform.workspace}-eau"
    location = var.location
}

# Storage Account
resource "azurerm_storage_account" "default" {
    name                     = "stocr${terraform.workspace}eau001"
    resource_group_name      = azurerm_resource_group.default.name
    location                 = azurerm_resource_group.default.location
    account_tier             = var.st_account_tier
    account_replication_type = var.st_account_replication_type
}

# App Service Plan
resource "azurerm_app_service_plan" "default" {
  name                = "asp-${terraform.workspace}-eau-001"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  kind                = var.asp_kind

  sku {
    tier = var.asp_sku_tier
    size = var.asp_sku_size
  }
}

# Function App
resource "azurerm_linux_function_app" "default" {
  name                = "fa-${terraform.workspace}-eau-001"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  storage_account_name       = azurerm_storage_account.default.name
  storage_account_access_key = azurerm_storage_account.default.primary_access_key
  service_plan_id            = azurerm_app_service_plan.default.id

  site_config {}
}

