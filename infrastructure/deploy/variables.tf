variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "location" {
  type = string
}

# Storage Account
variable "st_account_tier" {
  type = string
}

variable "st_account_replication_type" {
  type = string
}

# App Service Plan
variable "asp_os_type" {
  type = string
}

variable "asp_sku_name" {
  type = string
}