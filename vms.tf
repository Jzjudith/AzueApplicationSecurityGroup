resource "azurerm_linux_virtual_machine" "main1" {
  name                            = "devlinvm1"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B1s"
  admin_username                  = "devlab"
  admin_password                  = "Password123"
  network_interface_ids           = [azurerm_network_interface.nic1.id, ]
  disable_password_authentication = false
  user_data                       = filebase64("${path.module}/scripts/script1.sh")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

}
resource "azurerm_linux_virtual_machine" "main2" {
  name                            = "devlinvm2"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B1s"
  admin_username                  = "devlab"
  admin_password                  = "Password123"
  network_interface_ids           = [azurerm_network_interface.nic2.id, ]
  disable_password_authentication = false
  user_data                       = filebase64("${path.module}/scripts/script2.sh")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  depends_on = [
    azurerm_linux_virtual_machine.main1
  ]

}

