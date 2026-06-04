                    AWS
                     │
              ┌──────┴──────┐
              │   VPC custom │  (10.0.0.0/16)
              └──────┬──────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
   subnet-dev    subnet-staging  subnet-prod
  10.0.1.0/24   10.0.2.0/24   10.0.3.0/24
        │            │            │
   instance-dev  instance-stag  instance-prod
   t3.micro      t3.micro       t3.micro






# main.tf — vision finale
module "networking" { ... }           # crée VPC + subnets

module "compute_dev" {
  subnet_id = module.networking.subnet_dev_id      # ← rattachement
  sg_id     = module.networking.sg_dev_id
}

module "compute_staging" {
  subnet_id = module.networking.subnet_staging_id  # ← rattachement
  sg_id     = module.networking.sg_staging_id
}

module "compute_prod" {
  subnet_id = module.networking.subnet_prod_id     # ← rattachement
  sg_id     = module.networking.sg_prod_id
}


# Structure des fichiers
.
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── modules/
    ├── networking/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── compute/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf


|               | DEV         | STAGING           | PROD              |
| ------------- | ----------- | ----------------- | ----------------- |
| VPC CIDR      | 10.0.0.0/16 | 10.1.0.0/16       | 10.2.0.0/16       |
| Subnet        | 10.0.1.0/24 | 10.1.2.0/24       | 10.2.3.0/24       |
| SSH           | 0.0.0.0/0   | interne seulement | ton IP uniquement |
| Ports ouverts | 80          | 80, 443           | 80, 443, 8080     |
| Volume        | 10 Go       | 20 Go             | 30 Go             |