# Configuration de terraform avec aws


## aws terraform registry

https://registry.terraform.io/providers/hashicorp/aws/latest/docs

-- Declaration de la version du provider 
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```


Ce qui se passe sans le bloc terraform {}
Sans ce bloc, Terraform téléchargera automatiquement la dernière version disponible du provider AWS au moment du terraform init.

Le bloc required_providers devient utile dans ces cas :
- **En production** — figer une version pour éviter les surprises lors des mises à jour
- **En équipe** — garantir que tout le monde utilise le même provider
- **Compatibilité** — certaines ressources changent entre versions majeures


## les credentials 

Prérequis avant le **terraform apply**
Il faut configurer tes credentials AWS en local

```bash
aws configure
# AWS Access Key ID : (depuis IAM → ton user → clés d'accès)
# AWS Secret Access Key : ...
# Region : eu-west-3
```


❌ Ce qu'il ne faut JAMAIS faire

```text
# DANGER : clés en dur dans le code → commit Git = fuite de sécurité !
provider "aws" {
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG"
  region     = "eu-west-3"
}
```

La bonne méthode :
- variables d'environnement
```bash
# Linux/Mac — dans ton terminal avant terraform apply
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG"
export AWS_DEFAULT_REGION="eu-west-3"
```

**Lister les variables**

```bash
# Méthode 1 — affiche tout
printenv
# Méthode 2 — pareil
env
# Méthode 3 — avec défilement si liste longue
printenv | less

# Afficher une seule variable
echo $AWS_ACCESS_KEY_ID
printenv AWS_ACCESS_KEY_ID

# Très utile pour vérifier tes credentials AWS ✅
printenv | grep AWS
# → AWS_ACCESS_KEY_ID=AKIA...
# → AWS_SECRET_ACCESS_KEY=wJal...
# → AWS_DEFAULT_REGION=eu-west-3

```

**DEsallouer une variable**
```bash
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_DEFAULT_REGION
```


- Autre méthode : fichier ~/.aws/credentials
Si tu as installé AWS CLI, les credentials sont déjà stockés ici :
```bash
# Linux/Mac — dans ton terminal avant terraform apply
aws configure  # remplit ~/.aws/credentials automatiquement
```
Terraform les lit automatiquement sans rien configure

### Le tableau des priorités Terraform

| Priorité      | Méthode                         |
| ------------- | ------------------------------- |
| 1 (plus fort) | Variables d'environnement AWS_* |
| 2             | Fichier ~/.aws/credentials      |
| 3             | Rôle IAM de l'instance EC2      |
| 4 (à éviter)  | Hardcodé dans le .tf            |


### installer aws cli

- **Ubuntu**
```bash

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

- **AlmaLinux** 
```bash
sudo dnf install awscli 
```

### configurer les credentials

```text
AWS Access Key ID     : AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key : wJalrXUtnFEMI/K7MDENG...
Default region name   : eu-west-3
Default output format : json
```

### La priorité de la région dans Terraform
Terraform applique cet ordre pour trouver la région 

```text
1. provider "aws" { region = "eu-west-3" }   ← dans le .tf (priorité max)
2. Variable d'env AWS_DEFAULT_REGION          ← export dans le terminal
3. ~/.aws/config                              ← aws configure
4. us-east-1 par défaut                       ← ❌ à éviter
```



## Services AWS — Vue d'ensemble

AWS propose plus de 200 services, tous gérables avec Terraform. 

Voici un aperçu ([Découvrir les catégories de services AWS](https://trailhead.salesforce.com/fr/content/learn/modules/aws-cloud/discover-the-aws-service-categories))

### 🖥️ Compute

Les services de calcul permettent d'exécuter du code et des applications dans le cloud.

| Service | Description | Usage typique |
|---|---|---|
| **EC2** | Instances (machines virtuelles) | ✅ Ce qu'on a fait en cours |
| **Lambda** | Fonctions serverless | Exécution de code sans gérer de serveur |
| **ECS / EKS** | Containers Docker / Kubernetes | Applications conteneurisées |
| **Elastic Beanstalk** | Déploiement d'apps automatisé | PaaS — déployer sans gérer l'infra |

---

### 🗄️ Stockage

| Service | Description | Usage typique |
|---|---|---|
| **S3** | Stockage objet | Fichiers, images, backups, sites statiques |
| **EBS** | Disques pour instances EC2 | Volume attaché à une instance (comme un disque dur) |
| **EFS** | Système de fichiers partagé | Monté sur plusieurs instances simultanément |

---

### 🛢️ Base de données

| Service | Description | Usage typique |
|---|---|---|
| **RDS** | MySQL, PostgreSQL, MariaDB managés | BDD relationnelle sans gérer le serveur |
| **Aurora** | BDD haute performance AWS | Version boostée de MySQL/PostgreSQL |
| **DynamoDB** | NoSQL serverless | Données clé-valeur, haute scalabilité |
| **ElastiCache** | Redis / Memcached | Cache en mémoire pour accélérer les apps |

---

### 🌐 Réseau

| Service | Description | Usage typique |
|---|---|---|
| **VPC, Subnets, SG** | Réseau privé virtuel | ✅ Ce qu'on a fait en cours |
| **Route 53** | DNS | Résolution de noms de domaine |
| **CloudFront** | CDN mondial | Distribution de contenu au plus près des utilisateurs |
| **Load Balancer (ALB/NLB)** | Répartition de charge | Distribuer le trafic entre plusieurs instances |

---

### 🔐 Sécurité & Identité

| Service | Description | Usage typique |
|---|---|---|
| **IAM** | Gestion des droits / utilisateurs | Contrôle qui peut faire quoi sur AWS |
| **KMS** | Chiffrement des données | Gestion des clés de chiffrement |
| **WAF** | Pare-feu applicatif | Protéger les apps web contre les attaques |

---

### 📊 Monitoring

| Service | Description | Usage typique |
|---|---|---|
| **CloudWatch** | Logs, métriques, alertes | Surveiller les instances, déclencher des alarmes |
| **CloudTrail** | Audit de toutes les actions | Traçabilité — qui a fait quoi et quand |

---

### 📬 Messaging

| Service | Description | Usage typique |
|---|---|---|
| **SQS** | Files de messages | Communication asynchrone entre services |
| **SNS** | Notifications | Envoyer des alertes (email, SMS, Lambda) |
| **SES** | Envoi d'emails | Service d'envoi d'emails transactionnels |

---