resource "azurerm_resource_group" "main" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["10.0.0.0/16"]
  depends_on = [
    azurerm_resource_group.main
  ]
}

resource "azurerm_subnet" "main" {
  count                = 2
  name                 = "webserver-${count.index}"
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet
  address_prefixes     = [element(var.cidr, count.index)]
  depends_on = [
    azurerm_virtual_network.main
  ]
}



