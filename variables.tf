variable "resource_group_name" {
  description = "Nombre del resource group"
  type        = string
  default     = "rg-enterprise-ai-prod"
}

variable "location" {
  description = "Region de despliegue para los recursos cloud"
  type        = string
  default     = "westeurope"
}

variable "environment" {
  description = "Ambiente de ejecucion"
  type        = string
  default     = "production"
}

variable "prefix" {
  description = "Prefijo para nomenclatura estandarizada de recursos"
  type        = string
  default     = "ai-core"
}