resource "azurerm_application_security_group" "web" {
  name                = "web-vm-asg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [
    azurerm_linux_virtual_machine.main1
  ]
}

resource "azurerm_application_security_group" "dbs" {
  name                = "dbs-vm-asg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [
    azurerm_linux_virtual_machine.main2
  ]
}

resource "azurerm_network_security_group" "main" {
  name                = "web-db-nnsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

security_rule {
    name                       = "Allow-SSHToWeb"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.web.id]
  }
  
  security_rule {
    name                       = "Allow-SSHToDB"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.dbs.id]
  }


  security_rule {
    name                       = "Allow-OutboundToDB"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_application_security_group_ids = [azurerm_application_security_group.web.id]
    destination_application_security_group_ids = [azurerm_application_security_group.dbs.id]
  }

   security_rule {
    name                       = "Deny-InboundFromDB"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_application_security_group_ids = [azurerm_application_security_group.dbs.id]
    destination_application_security_group_ids = [azurerm_application_security_group.web.id]

  }

   security_rule {
    name                       = "Deny-Internet-"
    priority                   = 105
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Internet"
  }
} 

   resource "azurerm_network_interface_application_security_group_association" "web" {
    network_interface_id          = azurerm_network_interface.web.id
    application_security_group_id = azurerm_application_security_group.web.id
   }

   resource "azurerm_network_interface_application_security_group_association" "dbs" {
    network_interface_id          = azurerm_network_interface.dbs.id
    application_security_group_id = azurerm_application_security_group.dbs.id
   }

    resource "azurerm_subnet_network_security_group_association" "main1" {
    subnet_id                 = azurerm_subnet.web.id
    network_security_group_id = azurerm_network_security_group.main.id
  }
     resource "azurerm_subnet_network_security_group_association" "main2" {
     subnet_id                 = azurerm_subnet.dbs.id
     network_security_group_id = azurerm_network_security_group.main.id
  }

   