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

