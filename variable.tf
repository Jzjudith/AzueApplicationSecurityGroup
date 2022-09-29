variable "resource_group" {
  type        = string
  description = "Name of resource group"
  default     = "devlab-appsecgrp-rg"
}

variable "location" {
  type        = string
  description = "Name of location"
  default     = "East US2"
}

variable "vnet" {
  type        = string
  description = "Name of virtual network"
  default     = "devlab-vnet"
}

