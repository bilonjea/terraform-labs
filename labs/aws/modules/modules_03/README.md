# Modules externe s3 bucket

module "s3_prod"
    │
    └── crée automatiquement :
        ├── aws_s3_bucket
        ├── aws_s3_bucket_versioning
        ├── aws_s3_bucket_server_side_encryption_configuration
        ├── aws_s3_bucket_public_access_block
        └── aws_s3_bucket_ownership_controls

**Sans le module → 5 ressources à écrire manuellement. Avec → 10 lignes ✅**

Comment trouver un module sur la registry

https://registry.terraform.io
→ Chercher "s3" ou "ec2" ou "vpc"
→ Filtrer par "AWS" et trier par "Most Downloads"
→ Lire les inputs/outputs dans l'onglet "Inputs"


## Les modules AWS les plus populaires

| Module                                 | Usage               |
| -------------------------------------- | ------------------- |
| terraform-aws-modules/vpc/aws          | VPC complet         |
| terraform-aws-modules/s3-bucket/aws    | Bucket S3 sécurisé  |
| terraform-aws-modules/ec2-instance/aws | Instances EC2       |
| terraform-aws-modules/rds/aws          | Base de données RDS |
| terraform-aws-modules/eks/aws          | Cluster Kubernetes  |


