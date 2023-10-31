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
  name = "public-nsg"
  #checkov:skip=CKV_AZURE_10
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

resource "azurerm_subnet_nat_gateway_association" "packer-image-public-subnet-nat-assoc" {
  subnet_id      = azurerm_subnet.public-subnet.id
  nat_gateway_id = azurerm_nat_gateway.packer-image-natg.id
}

resource "azurerm_nat_gateway_public_ip_association" "packer-image-natg-pip-assoc" {
  nat_gateway_id       = azurerm_nat_gateway.packer-image-natg.id
  public_ip_address_id = azurerm_public_ip.packer-image-natg-pip.id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "packer-image-natg-ipprefix-assoc" {
  nat_gateway_id      = azurerm_nat_gateway.packer-image-natg.id
  public_ip_prefix_id = azurerm_public_ip_prefix.packer-image-natg-ipprefix.id
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

# Create an Azure subnet for bastion
resource "azurerm_subnet" "gateway-subnet" {
  name                 = "gateway-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.255.224/27"]
}

# Create an Azure subnet for bastion
resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.10.0/26"]
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

# Create public IP address for bastion host.
resource "azurerm_public_ip" "packer-image-bastion-pip" {
  name                = "packer-image-bastion-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_public_ip_prefix" "packer-image-natg-ipprefix" {
  name                = "packer-image-natg-ipprefix"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = 30
  tags                = var.tags
}

# Create public IP address for NAT Gateway.
resource "azurerm_public_ip" "packer-image-natg-pip" {
  name                = "packer-image-natg-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
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

# Create an Azure network interface
resource "azurerm_network_interface" "azxdev01-private-nic" {
  name                 = "azxdev01-private-nic"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "azxdev01-private-nic"
    subnet_id                     = azurerm_subnet.private-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.4"
  }
}

# Create an Azure route table
# resource "azurerm_route_table" "packer-image-gateway-rt" {
#   name                          = "packer-image-gateway-rt"
#   location                      = azurerm_resource_group.rg.location
#   resource_group_name           = azurerm_resource_group.rg.name
#   disable_bgp_route_propagation = false
#
#   route {
#     name           = "toHub"
#     address_prefix = "10.0.0.0/16"
#     next_hop_type  = "VnetLocal"
#   }

# route {
# name                   = "toSpoke1"
# address_prefix         = "10.1.0.0/16"
# next_hop_type          = "VirtualAppliance"
# next_hop_in_ip_address = "10.0.0.36"
# }

# route {
# name                   = "toSpoke2"
# address_prefix         = "10.2.0.0/16"
# next_hop_type          = "VirtualAppliance"
# next_hop_in_ip_address = "10.0.0.36"
# }
#
#  tags = var.tags
#}

resource "azurerm_nat_gateway" "packer-image-natg" {
  name                = "packer-image-natg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "Standard"
  tags                = var.tags
}

# Create an Azure virtual machine Extensions
# resource "azurerm_virtual_machine_extension" "enable-routes" {
#   name                 = "enable-iptables-routes"
#   virtual_machine_id   = azurerm_linux_virtual_machine.azxdev01.id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"
#
#   settings = <<SETTINGS
#     {
#         "fileUris": [
#         "https://raw.githubusercontent.com/mspnp/reference-architectures/master/scripts/linux/enable-ip-forwarding.sh"
#         ],
#         "commandToExecute": "bash enable-ip-forwarding.sh"
#     }
#     SETTINGS
#
#   tags = var.tags
# }

// Creating an Azure Bastion Host
resource "azurerm_bastion_host" "packer-image-bastion" {
  name                = "packer-image-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  // Setting the optional Bastion host settings based on SKU type
  copy_paste_enabled     = true
  file_copy_enabled      = true
  ip_connect_enabled     = true
  scale_units            = 2
  shareable_link_enabled = true
  tunneling_enabled      = true

  // Configuring IP settings for the Bastion host
  ip_configuration {
    name                 = "packer-image-bastion-pip-cfg"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.packer-image-bastion-pip.id
  }

  // Adding tags to the Bastion host
  tags = var.tags
}

# Create an Azure Linux virtual machine
resource "azurerm_linux_virtual_machine" "azxdev01" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "azxdev01"
  #checkov:skip=CKV_AZURE_50
  computer_name                   = "azxdev01"
  size                            = var.VMSize
  admin_username                  = var.admin_username
  disable_password_authentication = true
  # delete_data_disks_on_termination = true
  # delete_os_disk_on_termination    = true

  encryption_at_host_enabled = false
  tags                       = var.tags

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

  user_data = data.cloudinit_config.azxdev01-cloud-init.rendered
}

# Define a null_resource for installing Ansible
# resource "null_resource" "ansible_installation" {
#   triggers = {
#     # Trigger this resource whenever the VM is created or updated
#     virtual_machine_id = azurerm_linux_virtual_machine.azxdev01.id
#   }
#
#   # Use a local-exec provisioner to install Ansible
#   provisioner "local-exec" {
#     command = "sudo apt-get update && sudo apt-get install -y ansible"
#   }
# }

# Define a null_resource for running ansible-pull
# resource "null_resource" "ansible_provisioner" {
#   triggers = {
#     # Trigger this resource whenever the VM is created or updated
#     virtual_machine_id = azurerm_linux_virtual_machine.azxdev01.id
#   }
#
#   # Use a local-exec provisioner to run ansible-pull
#   provisioner "local-exec" {
#     command = "ansible-pull -U https://github.com/julianobarbosa/personal_ansible_desktop_configs.git -i hosts local.yml --limit azxdev01 --tags workstation"
#   }
# }

