## Azure CLI commands used here:

### Command to check the Azure ISE image details

Available ISE sku are - cisco-ise_3_2 and cisco-ise_3_3
``` 
az vm image list --all --publisher="cisco" --sku="cisco-ise_3_2"
```

### Command to check the Azure ISE image subscription status

Available ISE plan are - cisco-ise_3_2 and cisco-ise_3_3

```
az vm image terms show --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_2
```