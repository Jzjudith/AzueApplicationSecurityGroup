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

variable "cidr" {
  type        = list(string)
  description = "Subnets ip address range"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
