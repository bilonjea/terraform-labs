# Creation de son propre réseau VPC

-  aws_vpc
-  aws_internet_gateway
-  aws_route_table et aws_route_table_association
-  aws_subnet il possible d'avoir des sous-reseau non exposé au net et d'autre si 
-  aws_security_group avec des règles de routage ingres, egress



## La hiérarchie dans ton code
```text
VPC         : 10.0.0.0/16   → 65 536 adresses (ton réseau global)
  Subnet    : 10.0.1.0/24   → 256 adresses (ton sous-réseau)
    Instance: 10.0.1.x      → une IP privée dans cette plage
```

### Les 3 plages IP privées RFC 1918

| Classe | Plage          | Nb adresses |
| ------ | -------------- | ----------- |
| A      | 10.0.0.0/8     | 16 millions |
| B      | 172.16.0.0/12  | 1 million   |
| C      | 192.168.0.0/16 | 65 536      |


### Un VPC = plusieurs subnets possible

```text
VPC : 10.0.0.0/16
  ├── subnet public   : 10.0.1.0/24  → instances accessibles depuis Internet
  ├── subnet privé    : 10.0.2.0/24  → instances sans accès direct Internet (BDD...)
  └── subnet admin    : 10.0.3.0/24  → instances d'administration
```

En Terraform ça donne :

```text
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.formation.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "subnet-public" }
}

resource "aws_subnet" "prive" {
  vpc_id     = aws_vpc.formation.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  tags = { Name = "subnet-prive" }
}
```


### Les règles importantes

- Chaque subnet doit avoir un CIDR différent et non chevauchant
- Tous les subnets dans le même VPC peuvent communiquer entre eux par défaut
- Seuls les subnets avec map_public_ip_on_launch = true + une route vers l'Internet Gateway sont publics


### Architecture classique AWS

| Subnet | Contient              | Accessible depuis Internet |
| ------ | --------------------- | -------------------------- |
| Public | Serveurs web, bastion | ✅ Oui                      |
| Privé  | Base de données, API  | ❌ Non                      |
| Admin  | Outils de monitoring  | ⚠️ VPN seulement           |