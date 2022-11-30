resource "azurerm_linux_virtual_machine" "main" {
  count = 2
  name                = "server-${count.index}"
  resource_group_name = var.resource_group
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "devlab"
  admin_password      = "Password123"
  # network_interface_ids           = [element(azurerm_network_interface.main.*.id, count.index), ]
  network_interface_ids           = [element([for nic in azurerm_network_interface.main : nic.id], count.index), ]
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
  depends_on = [
    azurerm_network_interface.main
  ]

}
