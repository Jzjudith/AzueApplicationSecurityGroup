# resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group
  location = var.location
}

# virtual network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["10.0.0.0/16"]
  depends_on = [
    azurerm_resource_group.main
  ]
}

# subnets
resource "azurerm_subnet" "main" {
  for_each = {
    "web-subnet" = "10.0.1.0/24"
    "db-subnet"  = "10.0.2.0/24"
  }

  name                 = each.key
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet
  address_prefixes     = [each.value]
  depends_on = [
    azurerm_virtual_network.main
  ]
}

# public ip addresses
resource "azurerm_public_ip" "main" {
  count               = 2
  name                = "pub-ip-${count.index}"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.main
  ]

  tags = {
    environment = "DevOps"
  }
}

# network interfaces
resource "azurerm_network_interface" "main" {
  count               = 2
  name                = "nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ip-config-${count.index}"
    subnet_id                     = element([for subnet in azurerm_subnet.main : subnet.id], count.index)
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = element(azurerm_public_ip.main.*.id, count.index)
    public_ip_address_id          = element([for ip in azurerm_public_ip.main : ip.id], count.index)
  }

  depends_on = [
    azurerm_subnet.main
  ]
}







