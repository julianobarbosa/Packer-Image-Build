# Generate a random pet name for the Storage Account
resource "random_pet" "storage_account_name_random" {
  length    = 2
  separator = "-"
}

# Create an Azure resource group
resource "azurerm_resource_group" "rg" {
  name     = var.ResourceGroup
  location = var.Location
  tags     = var.tags
}

# Create an Azure virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.VirtualNetwork
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

# Create network security group and SSH rule for public subnet.
resource "azurerm_network_security_group" "public-nsg" {
  name                = "public-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Allow SSH traffic in from Internet to public subnet.
  security_rule {
    name                       = "allow-ssh-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate network security group with public subnet.
resource "azurerm_subnet_network_security_group_association" "public-subnet-assoc" {
  subnet_id                 = azurerm_subnet.public-subnet.id
  network_security_group_id = azurerm_network_security_group.public-nsg.id
}

# Create network security group and SSH rule for private subnet.
resource "azurerm_network_security_group" "private-nsg" {
  name                = "private-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Allow SSH traffic in from public subnet to private subnet.
  security_rule {
    name                       = "allow-ssh-public-subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  # Block all outbound traffic from private subnet to Internet.
  security_rule {
    name                       = "deny-internet-all"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate network security group with private subnet.
resource "azurerm_subnet_network_security_group_association" "private-subnet-assoc" {
  subnet_id                 = azurerm_subnet.private-subnet.id
  network_security_group_id = azurerm_network_security_group.private-nsg.id
}

# Create an Azure subnet
resource "azurerm_subnet" "private-subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  # List of Service endpoints to associate with the subnet.
  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.ServiceBus"
  ]
}

# Create public subnet for hosting bastion/public VMs.
resource "azurerm_subnet" "public-subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  # List of Service endpoints to associate with the subnet.
  service_endpoints = [
    "Microsoft.ServiceBus",
    "Microsoft.ContainerRegistry"
  ]
}

# Create network interface for bastion host VM in public subnet.
resource "azurerm_network_interface" "packer-image-bastion-nic" {
  name                = "packer-image-bastion-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "packer-image-bastion-nic-cfg"
    subnet_id                     = azurerm_subnet.public-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Create an Azure network interface
resource "azurerm_network_interface" "azxdev01-private-nic" {
  name                = "azxdev01-private-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "azxdev01-private-nic-cfg"
    subnet_id                     = azurerm_subnet.private-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create an Azure Storage Account
# resource "azurerm_storage_account" "storage_account" {
#   name                     = var.storage_account_name
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   access_tier              = "Hot"
# }

# Create bastion host VM.
resource "azurerm_virtual_machine" "packer-image-bastion-vm" {
  name                = "packer-image-bastion-vm001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [
    azurerm_network_interface.packer-image-bastion-nic.id
  ]
  vm_size = "Standard_DS1_v2"

  storage_os_disk {
    name              = "packer-image-bastion-dsk001"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "packer-image-bastion-vm001"
    admin_username = var.admin_username
    custom_data    = file("${path.module}/files/nginx.yaml")
  }

  os_profile_linux_config {
    disable_password_authentication = true

    # Bastion host VM public key.
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDa4t2F0FfXVmndPX0M81bBzJ0wRAr+z1jDcYA3keuIZxYI/QJdNp/eSBeo2Qg0/McKJN3HJOTRPH+bohPs9M8hbtlUaxj/XZwKZG+pQH6v9Pjs5fvwXYi+6X6Se1j7HwRDOdsh2nkOl2pKms0/M9vy0Bzm+cmwqa1mkTiI3S8RbUjMDhEqBZl/846m0oZ+dvos+5+f6XjUun4N3AahrwzqUpQMuSPxAF483UM681LXAeoiWViMmudBugShzFs1sGupI1OrYBhxcVJlX6kRLuFoyIbMsyWdi/0Lpo7V91xnDFiM7YZ+cuNmiz+T+vcv9WvHoVre5cN+vpE4DiQXWxM4OYgLP/hBL9rq00kPEgOM7xgJH+jOZSSd82MyykQ7VXe7CuxwdDnLnlBqfQd1n99D2jyo7571c9o4WI2PlMvGy7RDCDUmk+L5jvZu0KvykawE49gmBiMzQCKTJoTn0tuhkERgJFjGZHvufjhDOij3uE2wSP7NY1ZKpDc0bhEYP/s= pratika\\juliano.barbosa@N603085"
    }
  }

  tags = var.tags
}

# Create an Azure Linux virtual machine
resource "azurerm_linux_virtual_machine" "azxdev01" {
  # provider                        = azurerm.delete-things
  name                            = "azxdev01"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.VMSize
  admin_username                  = var.admin_username
  disable_password_authentication = true
  encryption_at_host_enabled      = false
  tags                            = var.tags

  network_interface_ids = [
    azurerm_network_interface.azxdev01-private-nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/hypera.pub")
  }

  os_disk {
    name                 = "azxdev01_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.ImageId

  # Configure the VM to use Azure Spot instances
  priority        = "Spot"
  eviction_policy = "Deallocate"
}

# Define a null_resource for installing Ansible
resource "null_resource" "ansible_installation" {
  triggers = {
    # Trigger this resource whenever the VM is created or updated
    virtual_machine_id = azurerm_linux_virtual_machine.azxdev01.id
  }

  # Use a local-exec provisioner to install Ansible
  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get install -y ansible"
  }
}

# Define a null_resource for running ansible-pull
resource "null_resource" "ansible_provisioner" {
  triggers = {
    # Trigger this resource whenever the VM is created or updated
    virtual_machine_id = azurerm_linux_virtual_machine.azxdev01.id
  }

  # Use a local-exec provisioner to run ansible-pull
  provisioner "local-exec" {
    command = "ansible-pull -U https://github.com/julianobarbosa/personal_ansible_desktop_configs.git -i local.yml"
  }
}

