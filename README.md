# Introduction
Create Golden Image for Azure (hypera).
# ansible
## to install ansible
```bash
python -m pip install 'ansible[azure]==2.9.5' --upgrade --forc
```

## to test ansible
### create a resource group
```bash
ansible localhost -m azure_rm_resourcegroup -a "name=ansible-test location=eastus" -vvv
```

### remove a resource group
```bash
ansible localhost -m azure_rm_resourcegroup -a 'name=ansible-test location=eastus state=absent'
```

# to export group variables
```bash
az pipelines variable-group show --group-id "2" --org "https://dev.azure.com/hyperadevops" -p "golden-image" --output json > 1.json
```

# Linux
## to build ubuntu Image
```bash
packer build ubuntu-n590590.json
```

## to build local (notebook) with variable file
```bash
packer build -var-file=ubuntu-n590590-var.json ubuntu-n590590.json
```
