# Variables
ANSIBLE_PLAYBOOK := ansible-playbook
PLAYBOOK := local.yml
INVENTORY_SCRIPT := get_hosts.sh
INVENTORY := inventory/hosts.ini
IMAGE_NAME := mylinux
DOCKERFILE := Dockerfile
CONTAINER_NAME := $(IMAGE_NAME)
SHELL := /bin/zsh
VM_SIZE_HIGH := Standard_B1s
VM_SIZE_LOW := Standard_B1s
myVM_ID := /subscriptions/51f4e493-4815-4858-8bbb-f263e7fb63d6/resourceGroups/rg-hypera-packer-image/providers/Microsoft.Compute/virtualMachines/azxdev01
# VM_IP := $(shell az vm show -d -g myResourceGroup -n $(myVM) --query publicIps -o tsv)
VM_IP := 10.0.2.4
VM_PORT := 50022
KEY_PATH := ~/.ssh/hypera.ppk

# Define targets that don't generate files
.PHONY: init recreate refresh fmt plan apply destroy validate checkov help

# Default target
default: help

init: ## Initialize Terraform
	@packer init .

build: ## Initialize Terraform
	@packer build .

install:
	@packer install .

validate: ## Validate Terraform configuration
	@terraform validate

checkov: ## Run Checkov security checks
	@checkov --directory .

meta: ## Create an SSH tunnel to an Azure VM in the background
	# Replace VM_IP, VM_PORT, and KEY_PATH with actual values
	@echo "Starting MetaGPT ..."
	docker run --rm \
    --privileged \
    -v /opt/metagpt/config/key.yaml:/app/metagpt/config/key.yaml \
    -v /opt/metagpt/workspace:/app/metagpt/workspace \
    metagpt/metagpt:latest \
    python startup.py "$$3"

help: ## Show this help message
	@echo "Usage: make [target]"
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
