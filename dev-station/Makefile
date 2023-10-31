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
	@terraform init

remove-ssh-keygen:
	@ssh-keygen -f "/home/barbosa/.ssh/known_hosts" -R "[127.0.0.1]:50022"

recreate: ## Recreate resources with Terraform
	@terraform apply -replace "azurerm_linux_virtual_machine.azxdev01"
	@remove-ssh-keygen

refresh: validate ## Refresh Terraform plan
	@terraform plan --refresh-only --out tfplan

fmt: ## Format Terraform configuration
	@terraform fmt -recursive

plan: validate ## Generate Terraform plan
	@terraform plan -out tfplan

apply: ## Apply Terraform plan
	@terraform apply tfplan
	@remove-ssh-keygen

destroy: ## Destroy Terraform resources
	@terraform destroy
	@remove-ssh-keygen

validate: ## Validate Terraform configuration
	@terraform validate

checkov: ## Run Checkov security checks
	@checkov --directory .

low_performance: ## Connect to the Bastion host
	# Add your command here to connect to the Bastion host
	@echo "Change VM perfil to low performance ..."


high_performance: ## Connect to the Bastion host
	# Add your command here to connect to the Bastion host
	@echo "Change VM perfil to high performance host..."

bastion: ## Connect to the Bastion host
	# Add your command here to connect to the Bastion host
	@echo "Connecting to the Bastion host..."

ssh: ## Create an SSH tunnel to an Azure VM in the background
	# Replace VM_IP, VM_PORT, and KEY_PATH with actual values
	nohup az vm create-ssh --resource-group myResourceGroup --name myVM --ip-address VM_IP --port VM_PORT --private-key KEY_PATH > /dev/null 2>&1 & echo $$! > $$(SSH_PID_FILE)

tunnel: ## Create an tunnel to an Azure bastion in the background
	# Replace VM_IP, VM_PORT, and KEY_PATH with actual values
	az network bastion tunnel --name $$ARM_BASTION_NAME --resource-group $$ARM_RESOURCE_GROUP --target-ip-address $$VM_IP --resource-port 22 --port $$VM_PORT > /dev/null 2>&1 & echo $$! > $$(TUNNEL_PID_FILE)

kill_tunnel: ## Kill the SSH tunnel process
	@if [ -f $(TUNNEL_PID_FILE) ]; then \
		kill $$(cat $(TUNNEL_PID_FILE)); \
		rm -f $$(TUNNEL_PID_FILE); \
		echo "SSH tunnel process killed"; \
	else \
		echo "No tunnel process to kill"; \
	files
help: ## Show this help message
	@echo "Usage: make [target]"
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
