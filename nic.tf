resource "azurerm_network_interface" "web" {
  name                = "webserver1nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "webipconfig"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
    
  }
}

resource "azurerm_network_interface" "dbs" {
  name                = "wdatabase-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "dbsipconfig"
    subnet_id                     = azurerm_subnet.dbs.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dbs.id
   
  }
}

