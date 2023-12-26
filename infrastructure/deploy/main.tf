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
    name     = "rg-${var.project_id}-${var.env}-eau"
    location = var.location
}

# Storage Account
resource "azurerm_storage_account" "default" {
    name                     = "st${var.project_id}${var.env}eau001"
    resource_group_name      = azurerm_resource_group.default.name
    location                 = azurerm_resource_group.default.location
    account_tier             = var.st_account_tier
    account_replication_type = var.st_account_replication_type
}

# App Service Plan
resource "azurerm_service_plan" "default" {
  name                = "asp-${var.project_id}-${var.env}-eau-001"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  os_type = var.asp_os_type
  sku_name = var.asp_sku_name

}

# Function App
resource "azurerm_linux_function_app" "default" {
  name                = "fa-${var.project_id}-${var.env}-eau-001"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  storage_account_name       = azurerm_storage_account.default.name
  storage_account_access_key = azurerm_storage_account.default.primary_access_key
  service_plan_id            = azurerm_service_plan.default.id



  site_config {
    always_on = var.fa_always_on
    application_stack {
      python_version = var.fa_python_version
    }
  }
}

# Github Secrets / Variables
data "github_repository" "repo" {
  full_name = "${var.gh_repo_owner}/${var.gh_repo_name}"
}

resource "github_actions_environment_variable" "action_variable_fa_name" {
  repository       = data.github_repository.repo.name
  environment      = var.env
  variable_name    = "FUNCTION_APP_NAME"
  value            = azurerm_linux_function_app.default.name
}