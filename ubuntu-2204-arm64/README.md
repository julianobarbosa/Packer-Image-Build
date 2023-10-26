# Azure Images
## to list azure image
```bash
az vm image list --all --location eastus --publisher="Canonical" --sku="22_04-lts-gen2"
# or
az vm image show --location eastus --urn canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest

```
