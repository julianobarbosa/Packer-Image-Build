# to connect bastion SSH
##
```bash
az network bastion ssh --name bastion-host --resource-group bastion-test-rg --target-resource-id /subscriptions/{subscription-id}/resourceGroups/bastion-test-rg/providers/Microsoft.Compute/virtualMachines/vm-ubn-01 --auth-type "ssh-key" --username ubn-azureuser --ssh-key .\ssh_private_key.pem
```
