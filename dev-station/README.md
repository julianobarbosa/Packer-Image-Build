# to connect bastion SSH
##
```bash
az network bastion ssh --name bastion-host --resource-group bastion-test-rg --target-resource-id /subscriptions/{subscription-id}/resourceGroups/bastion-test-rg/providers/Microsoft.Compute/virtualMachines/vm-ubn-01 --auth-type "ssh-key" --username ubn-azureuser --ssh-key .\ssh_private_key.pem
```

## to connect azxdev01

```bash
az network bastion ssh --name $ARM_BASTION_NAME --resource-group $ARM_RESOURCE_GROUP --target-resource-id "/subscriptions/51f4e493-4815-4858-8bbb-f263e7fb63d6/resourceGroups/rg-hypera-packer-image/providers/Microsoft.Compute/virtualMachines/azxdev01" --auth-type "ssh-key" --username "hypera_user" --ssh-key "~/.ssh/hypera.ppk"

```

## to create tunnel
```bash
az network bastion tunnel --name $ARM_BASTION_NAME --resource-group $ARM_RESOURCE_GROUP --target-ip-address 10.0.2.4 --resource-port 22 --port 50022
```

## to create tunnel when get error SSL
```bash
AZURE_CLI_DISABLE_CONNECTION_VERIFICATION=1 az network bastion tunnel --name $ARM_BASTION_NAME --resource-group $ARM_RESOURCE_GROUP --target-ip-address 10.0.2.4 --resource-port 22 --port 50022
```

# Terraform
## to destroy only resource
```bash
terraform destroy -target="azurerm_virtual_machine.WS"

```

## to remote resource bastion
```bash
terraform destroy -target="azurerm_bastion_host.packer-image-bastion" \
-target="azurerm_public_ip.packer-image-bastion-pip" \
-target="azurerm_linux_virtual_machine.azxdev01" \
-target="azurerm_network_interface.azxdev01-private-nic"
```

# Azure CLI
## to list VM
```bash
az vm list -d -g $ARM_RESOURCE_GROUP --query '[].[name,powerState,provisioningState]'

```
# Ansible
## ansible-playbook
```bash
ansible-playbook -i hosts local.yml --limit azxdev01 --tags "packages,ansible,ansible-setup,workstation,gnome,gnome-packages"
```
