## Below Azure Resources will be created/required in the setup

- Resource Group
- 1-Virtual Network, 3-Public Subnets(optional-notrequired), 3-Private Subnets(2-VM+LB and, 1-Delegated Subnet for VNET integration with Function App), Private DNS zone, App Configuration.
- Function App, App Service Plan B1 - linux, Application Insights and Storage account
- Virtual Machines - 4 (2-Primary, Secondary nodes and 2-PSN nodes)
- Internal Load balancer