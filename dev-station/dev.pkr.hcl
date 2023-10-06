
variable "ADOAppID" {
  type = string
}

variable "ADOAppSecret" {
  type = string
}

variable "ImageDestRG" {
  type = string
}

variable "SubscriptionID" {
  type = string
}

variable "TenantID" {
  type = string
}

variable "VMName" {
  type = string
}

# could not parse template for following block: "template: hcl2_upgrade:2: bad character U+0060 '`'"

source "Microsoft.Compute/virtualMachines" "{{_user_`VMName`_}}" {
  azure_tags = {
    Projeto = "INFRA_SO"
    job     = "DevOps Workstation"
    task    = "Image deployment"
  }
  client_id                         = "{{ user `ADOAppID` }}"
  client_secret                     = "{{ user `ADOAppSecret` }}"
  image_offer                       = ""
  image_publisher                   = ""
  image_sku                         = ""
  location                          = "East US"
  managed_image_name                = "img-ubuntu-2204--2023-10-04T16-43-01Z"
  managed_image_resource_group_name = "{{ user `ImageDestRG` }}"
  osProfile = {
    adminPassword = "Senha@123"
    adminUsername = "barbosa"
    computerName  = "{{ user `VMName` }}"
  }
  os_type = "Linux"
  properties {
    hardwareProfile = {
      vmSize = "Standard_DS2_v2"
    }
  }
  storageProfile {
    imageRefence = {
      id = "/subscriptions/51f4e493-4815-4858-8bbb-f263e7fb63d6/resourceGroups/rg-hypera-packer-image/providers/Microsoft.Compute/images/img-ubuntu-2204--2023-10-04T16-43-01Z"
    }
    osDisk {
      createOption = "FromImage"
      managedDisk = {
        storageAccountType = "Standard_LRS"
      }
    }
  }
  subscription_id = "{{ user `SubscriptionID` }}"
  tenant_id       = "{{ user `TenantID` }}"
  vm_size         = "Standard_DS2_v2"
}

build {
  sources = ["source.Microsoft.Compute/virtualMachines.{{_user_`VMName`_}}"]

  provisioner "shell" {
    script = "provisioners/scripts/workstation.sh"
  }

}
