# Data souce 

| Champ console       | Utilisation dans Terraform                     |
| ------------------- | ---------------------------------------------- |
| ID de l'image       | ami-xxx → à mettre directement ou via data     |
| Nom                 | → pattern du filtre name avec * comme wildcard |
| Virtualisation hvm  | → filtre virtualization-type                   |
| Architecture x86_64 | → filtre architecture                          |
| Nom d'utilisateur   | → ubuntu ou ec2-user pour le SSH               |


Utilisation dans aws_instance

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux_2023.id  # ✅ toujours la dernière
  instance_type = "t3.micro"
}


## Voici les data sources Terraform AWS les plus courantes, organisées par catégorie

**🖥️ Compute**


```text
# Dernière AMI
data "aws_ami" "ubuntu" { ... }

# Informations sur une instance existante
data "aws_instance" "existing" {
  instance_id = "i-1234567890"
}
```

**🌐 Réseau**

```text
# VPC par défaut ou existant
data "aws_vpc" "default" {
  default = true
}

# Subnets d'un VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Subnet spécifique
data "aws_subnet" "selected" {
  id = "subnet-xxxxx"
}

# Security Group existant
data "aws_security_group" "existing" {
  name = "mon-sg"
}
```


**IAM & Sécurité**
```text
# Récupérer son propre compte AWS
data "aws_caller_identity" "current" {}
# Utilisation : data.aws_caller_identity.current.account_id

# Politique IAM
data "aws_iam_policy" "admin" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Role IAM existant
data "aws_iam_role" "existing" {
  name = "mon-role"
}
```

**🗄️ Stockage**
```text
# Bucket S3 existant
data "aws_s3_bucket" "existing" {
  bucket = "mon-bucket"
}
```


**🌍 Région & Zones**
```text
# Région courante
data "aws_region" "current" {}
# Utilisation : data.aws_region.current.name → "eu-west-3"

# Zones de disponibilité disponibles
data "aws_availability_zones" "available" {
  state = "available"
}
# Utilisation : data.aws_availability_zones.available.names[0] → "eu-west-3a"
```


**Cas d'usage typique — tout combiner**
# Récupère le VPC default + ses subnets + la région
data "aws_vpc" "default" { default = true }
data "aws_region" "current" {}
data "aws_availability_zones" "azs" { state = "available" }

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnets.public.ids[0]  # ✅ premier subnet dispo

  tags = {
    Region = data.aws_region.current.name         # ✅ eu-west-3
  }
}


Règle d'or → les data sources permettent de lire des ressources existantes sans les recréer — idéal pour référencer des ressources créées en dehors de Terraform
