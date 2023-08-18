#!/bin/bash
az vm image list \
  --publisher MicrosoftWindowsDesktop \
  --offer office-365 \
  --sku win11-21h2-avd-m365 \
  --all
