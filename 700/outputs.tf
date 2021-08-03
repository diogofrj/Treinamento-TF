output "PIP-LINUX" {
  value = azurerm_linux_virtual_machine.vmlinux.public_ip_address
}
/*
output "PIP-WINDOWS" {
  value = "mstsc v:/${azurerm_windows_virtual_machine.vmwin.public_ip_address}"
}
*/