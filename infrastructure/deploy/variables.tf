# General
variable "project_id" {
  type = string
}

variable "env" {
  type = string
}

variable "location" {
  type = string
}

# SPN
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

# Github
variable "gh_repo_owner" {
  type = string
}

variable "gh_repo_name" {
  type = string
}

# Storage Account
variable "st_account_tier" {
  type = string
}

variable "st_account_replication_type" {
  type = string
}

variable "st_container_name_image_upload" {
  type = string
}

# Key Vault
variable "kv_sku_name" {
  type = string
}

variable "kv_soft_delete_retention_days" {
  type = number
}

variable "secret_ocr_api_key" {
  type = string
}

# Service Plan
variable "asp_os_type" {
  type = string
}

variable "asp_sku_name" {
  type = string
}

# Function App
variable "fa_python_version" {
  type = string
}

variable "fa_cors_allowed_origins" {
  type = list(string)
}

variable "fa_always_on" {
  type = bool
}