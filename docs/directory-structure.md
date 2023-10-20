## Terraform directory structure

Below is the cloned repository directory structure

```
.
├── README.md
├── examples
│   ├── create-vm-with-existing-vnet
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── create-vm-with-new-vnet
│       ├── main.tf
│       ├── output.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── module
│   ├── loadbalancer_dns
│   │   ├── functionapp.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variable.tf
│   └── vm
│       ├── main.tf
│       ├── output.tf
│       ├── providers.tf
│       ├── user_data.tftpl
│       └── variables.tf
├── providers.tf
├── terraform.tfvars
└── variables.tf
```