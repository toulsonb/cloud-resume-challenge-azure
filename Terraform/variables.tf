variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, prod)."
  default     = "prod"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources will be deployed."
  default     = "centralus"  # This region is selected because the current subscriptions limit us of eastus for most of the resources to be used
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where resources will be deployed."
  default     = "rg-cloudresume-prod"
}

variable "unique_prefix" {
  type        = string
  description = "A unique lowercase prefix to prevent global naming conflicts for storage and database accounts."
  default     = "cloudresumebt"
}