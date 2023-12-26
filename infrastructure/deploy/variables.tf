# General
variable "project_id" {
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

# Storage Account
variable "st_account_tier" {
  type = string
}

variable "st_account_replication_type" {
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

variable "fa_always_on" {
  type = bool
}