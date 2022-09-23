output "web1pip" {
  value = azurerm_public_ip.web1.ip_address
}

output "web2pip" {
  value = azurerm_public_ip.web2.ip_address
}
