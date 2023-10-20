## Terraform directory structure

Below is the cloned repository directory structure

```
.
├── README.md
├── docs
│   ├── azure-cli-commands.md
│   ├── directory-structure.md
│   └── resource-created.md
├── examples
│   ├── create-vm-with-existing-vnet
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── create-vm-with-new-vnet
│       ├── README.md
│       ├── main.tf
│       ├── output.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       └── variables.tf
└── module
    ├── loadbalancer_dns
    │   ├── functionapp.tf
    │   ├── main.tf
    │   ├── output.tf
    │   └── variable.tf
    └── vm
        ├── main.tf
        ├── output.tf
        ├── providers.tf
        ├── user_data.tftpl
        └── variables.tf

```