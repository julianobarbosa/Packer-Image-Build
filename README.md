# Introduction
Create Golden Image for Azure (hypera).
# to export group variables
```bash
az pipelines variable-group show --group-id "2" --org "https://dev.azure.com/hyperadevops" -p "golden-image" --output json > 1.json
```
