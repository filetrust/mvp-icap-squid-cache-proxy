#!/bin/bash
source config.sh
ALLOWEDIPS="${ALLOWEDIPS:-$(curl https://ipinfo.io/ip)}"
sed "s/#ADDITIONAL_ACL/acl localnet src $ALLOWEDIPS/g" cloud-init.txt.example > cloud-init.txt
az vm create \
    --resource-group "$RESOURCEGROUP" \
    --name "$VMNAME" \
    --image UbuntuLTS \
    --admin-username azureuser \
    --ssh-key-values "$SSHPUBKEY" \
    --custom-data cloud-init.txt | grep --color=auto -e '^' -e '.*publicIpAddress.*'
az network nsg rule create --resource-group "$RESOURCEGROUP" --name mySSH --nsg-name "$VMNAME"NSG \
--protocol tcp --source-address-prefixes $ALLOWEDIPS --destination-port-ranges 22   --priority 200
az network nsg rule create --resource-group "$RESOURCEGROUP" --name mySSH --nsg-name "$VMNAME"NSG \
--protocol tcp --source-address-prefixes $ALLOWEDIPS --destination-port-ranges 3128 --priority 200
