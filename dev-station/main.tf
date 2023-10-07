# Create an Azure resource group
resource "azurerm_resource_group" "rg" {
  name     = var.ResourceGroup
  location = var.Location
}

# Create an Azure virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.VirtualNetwork
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create an Azure subnet
resource "azurerm_subnet" "vnet-internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create an Azure network interface
resource "azurerm_network_interface" "azxdev01-nic" {
  name                = "azxdev01-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet-internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create an Azure Linux virtual machine
resource "azurerm_linux_virtual_machine" "azxdev01" {
  name                = "azxdev01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.azxdev01-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    id = var.ImageId
  }
}

