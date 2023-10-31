# Boilerplate Packer configuration file

packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
  }
}

source "azure-arm" "image" {
  # Placeholder values - replace with actual values
  client_id                         = "CLIENT_ID"
  client_secret                     = "CLIENT_SECRET"
  image_offer                       = "IMAGE_OFFER"
  image_publisher                   = "IMAGE_PUBLISHER"
  image_sku                         = "IMAGE_SKU"
  location                          = "LOCATION"
  managed_image_name                = "IMAGE_NAME"
  managed_image_resource_group_name = "RESOURCE_GROUP_NAME"
  os_type                           = "OS_TYPE"
  subscription_id                   = "SUBSCRIPTION_ID"
  tenant_id                         = "TENANT_ID"
  vm_size                           = "VM_SIZE"
}

build {
  sources = ["source.azure-arm.image"]

  provisioner "shell" {
    # Placeholder values - replace with actual values
    execute_command = "EXECUTE_COMMAND"
    inline_shebang  = "INLINE_SHEBANG"
    scripts         = ["SCRIPT_PATH"]
  }
}
