resource "azurerm_network_interface" "main" {
  count               = 2
  name                = "nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ip-config-${count.index}"
    subnet_id                     = element(azurerm_subnet.main.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.main.*.id, count.index)
  }

  depends_on = [
    azurerm_subnet.main
  ]
}


