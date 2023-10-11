terraform {
  required_version = ">= 1.6"
  required_providers {
    ansible = {
      version = "~> 1.1.0"
      source  = "ansible/ansible"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.0.4"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
}

provider "azurerm" {
  alias                      = "delete-things"
  skip_provider_registration = true
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
}

provider "azurerm" {
  alias                      = "save-things"
  skip_provider_registration = true
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false
    }
  }
}

provider "null" {
  # Configuration options
}

provider "random" {
  # Configuration options
}
