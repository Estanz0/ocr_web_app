###########################
# Existing Infrastructure #
###########################

# Subscription
data "azurerm_subscription" "default" {}

# SPN
data "azurerm_client_config" "current" {}

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

resource "azurerm_storage_container" "default" {
  name                  = var.st_container_name_image_upload
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "blob"
}

resource "azurerm_role_assignment" "spn_sbdc" {
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Key Vault
resource "azurerm_key_vault" "default" {
  name                        = "kv-${var.project_id}-${var.env}-eau-001"
  location                    = azurerm_resource_group.default.location
  resource_group_name         = azurerm_resource_group.default.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.kv_sku_name
  soft_delete_retention_days  = var.kv_soft_delete_retention_days

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [ "Create", "Delete", "Get", "List", "Update" ]
    secret_permissions = [ "Delete", "Get", "List", "Set" ]
  }

  lifecycle {
    ignore_changes = [
      access_policy,
    ]
  }
}

resource "azurerm_key_vault_secret" "ocr_api_key" {
  name         = "ocrapikey"
  value        = var.secret_ocr_api_key
  key_vault_id  = azurerm_key_vault.default.id
}

# App Service Plan
resource "azurerm_service_plan" "default" {
  name                = "asp-${var.project_id}-${var.env}-eau-001"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  os_type = var.asp_os_type
  sku_name = var.asp_sku_name

}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${var.project_id}-${var.env}-eau-001"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

# Application Insights
resource "azurerm_application_insights" "default" {
  name                = "appi-${var.project_id}-${var.env}-eau-001"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  application_type    = "web"

  workspace_id = azurerm_log_analytics_workspace.default.id
}

# Function App
resource "azurerm_linux_function_app" "default" {
  name                = "fa-${var.project_id}-${var.env}-eau-001"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  storage_account_name       = azurerm_storage_account.default.name
  storage_account_access_key = azurerm_storage_account.default.primary_access_key
  service_plan_id            = azurerm_service_plan.default.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = var.fa_always_on

    application_insights_key = azurerm_application_insights.default.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.default.connection_string

    application_stack {
      python_version = var.fa_python_version
    }
  }

  app_settings = {
    "STORAGE_ACCOUNT_URL_IMAGE_UPLOAD": azurerm_storage_account.default.primary_blob_endpoint,
    "STORAGE_CONTAINER_NAME_IMAGE_UPLOAD": azurerm_storage_container.default.name,
    "OCR_API_KEY": "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.default.vault_uri}secrets/${azurerm_key_vault_secret.ocr_api_key.name}/)"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_key_vault_access_policy" "default" {
  count = azurerm_linux_function_app.default.identity[0].principal_id != null ? 1 : 0
  key_vault_id = azurerm_key_vault.default.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_function_app.default.identity[0].principal_id

  key_permissions = [ "Create", "Delete", "Get", "List", "Update" ]
  secret_permissions = [ "Delete", "Get", "List", "Set" ]
}

resource "azurerm_role_assignment" "fa_sami_sbdc" {
  count = azurerm_linux_function_app.default.identity[0].principal_id != null ? 1 : 0
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.default.identity[0].principal_id
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

resource "github_actions_environment_variable" "action_variable_fa_url" {
  repository       = data.github_repository.repo.name
  environment      = var.env
  variable_name    = "FUNCTION_APP_URL"
  value            = azurerm_linux_function_app.default.default_hostname
}

resource "github_actions_environment_variable" "action_variable_fa_python_version" {
  repository       = data.github_repository.repo.name
  environment      = var.env
  variable_name    = "FUNCTION_APP_PYTHON_VERSION"
  value            = var.fa_python_version
}