resource "azurerm_network_interface" "test-nic-lengyel" {
  name                = "${var.name}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.public_ip_address_id}"
  }
}

resource "azurerm_linux_virtual_machine" "test-vm-lengyel" {
  name                = "${var.name}-vm"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  size                = "${var.size}"
  admin_username      = "lukas"
  network_interface_ids = [azurerm_network_interface.test-nic-lengyel.id]
  disable_password_authentication = true
  admin_ssh_key {
    username   = "lukas"
    #public_key = file(".ssh/project3_id_rsa.pub")
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5AalIHe4/Ys1WRW3qU7FnOho4SCQLafSdgGE8/tbTBIkK3XxAvERrojSMow3zWDiDrdcdR4/k+yM1UansQSRCDYMIr7OXv6mkxggEMAM8rHdpqEpOW/gkEkMxwnd8/ko5Z8VCojDpm+epn+0BsWz570UjVmEj4tyI1zDc3x36XdNYOEzrLBoIOjy+mnzUqEClGwcNEMpjnY30L6DVLPeT1zx2DLXkLCsSb2eOFXCf5eBoxlbdqBtBE+dhYcgWyKfuBgk8a2hvIeYzNeeHkLsvq3kMl45BBmzDMEF1USRPZvz+fBx5eo0JVUSQHHlqmy2a84VYN6cqZfsgQuZPNyMWpEaEjxdTEXPIvfWA1EOnBpcvu+b7whY2UCNTe9wZgVXc0bRkPQY7NUK4hY6cqUiAW+OxiVEuZcLEwmW9fGptQrGONhC1Uunmp+afD6wQxVo7LLX+TNeGFtVenKqGGnmyS0j3+6sjAaNmermxHWNvgQYraKI9Rzeyg4Koeb9Qin3IxW4TVN745u8vUQlMpu8C1qKjFi+Lc0+9H275EREo7Dl88QTOGrZ+VcfOud9Sz9EsbmVBj+Rx62JXd8Id4hBQNYCYYhkSZDRWEzO2Wc5fgV9Fa9oMTMW6tpwI6mdgCKkL/AAdD+me3mrZwp2NGd7CuFN0CG6YRRwAlXXPw60WRQ== lukas@lukas-ThinkPad-E480"
  }

  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
