# GCP 


## Les conditions du free tier GCP

| Condition                    | Valeur                          |
| ---------------------------- | ------------------------------- |
| Type d'instance              | e2-micro uniquement             |
| Régions éligibles            | us-central1, us-east1, us-west1 |
| Nombre d'instances gratuites | 1 par mois                      |
| Disque boot                  | 30 GB standard inclus           |


## Credential 

**Méthode 1 — Variable d'env (recommandée pour GCP)**
GCP a une variable d'environnement native que Terraform lit automatiquement :
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/home/bilonjea/.gcp/linen-inscriber-311821-09e81bf53e7e.json"
```

**Méthode 2 — Chemin absolu hors du projet**
Si tu veux garder file(), pointe vers un dossier en dehors du projet Git :
```text
credentials = file("~/.gcp/linen-inscriber-311821-09e81bf53e7e.json")
```


**Créer le dossier et déplacer le fichier hors du projet**
```bash
mkdir -p ~/.gcp
mv linen-inscriber-311821-09e81bf53e7e.json ~/.gcp/
chmod 600 ~/.gcp/linen-inscriber-311821-09e81bf53e7e.json  # sécuriser les permissions
```

**Méthode 3 — Variable Terraform (bonne pour le cours)**

```text
# variables.tf
variable "gcp_credentials" {
  description = "Chemin vers le fichier JSON GCP"
  type        = string
}

# provider.tf
provider "google" {
  credentials = file(var.gcp_credentials)
  project     = "linen-inscriber-311821"
  region      = "us-central1"
}
```


**Au lancement**
```bash
terraform apply -var="gcp_credentials=~/.gcp/linen-inscriber-311821.json"
```


** Ajouter dans .gitignore**
```bash
echo "*.json" >> .gitignore
echo ".gcp/" >> .gitignore
```



## GCP vs AWS — Comparatif Terraform

### Authentification & Credentials

|                     | AWS                                       | GCP                                            |
| ------------------- | ----------------------------------------- | ---------------------------------------------- |
| Fichier credentials | ~/.aws/credentials via aws configure      | Fichier JSON téléchargé depuis la console      |
| Variable d'env      | AWS_ACCESS_KEY_ID + AWS_SECRET_ACCESS_KEY | GOOGLE_APPLICATION_CREDENTIALS                 |
| Dans le provider    | Rien (lu automatiquement)                 | credentials = file("...") ou rien si var d'env |


### Provider Terraform

|                    | AWS                    | GCP                       |
| ------------------ | ---------------------- | ------------------------- |
| Source             | hashicorp/aws          | hashicorp/google          |
| Paramètres         | region                 | project + region          |
| Identifiant projet | Account ID (implicite) | project = "mon-projet-id" |


### Compute (Machine Virtuelle)

|              | AWS                              | GCP                                       |
| ------------ | -------------------------------- | ----------------------------------------- |
| Ressource    | aws_instance                     | google_compute_instance                   |
| Type machine | instance_type = "t3.micro"       | machine_type = "e2-micro"                 |
| Image        | ami = "ami-xxxxx" (par région !) | image = "ubuntu-os-cloud/ubuntu-2204-lts" |
| Free tier    | t3.micro (750h/mois)             | e2-micro (1 instance us-central1)         |
| Zone         | availability_zone                | zone                                      |


### Réseau & Firewall

|                       | AWS                                | GCP                                         |
| --------------------- | ---------------------------------- | ------------------------------------------- |
| Ressource firewall    | aws_security_group                 | google_compute_firewall                     |
| Liaison instance      | vpc_security_group_ids = [sg.id]   | tags = ["http-server"] ↔ target_tags        |
| Type de liaison       | Par ID de ressource                | Par tag texte                               |
| VPC par défaut        | Existe mais souvent recréé         | network = "default" suffit                  |
| IP publique           | associate_public_ip_address = true | access_config {} dans network_interface     |
| Tout fermé par défaut | ✅ oui                              | ✅ oui (mais default network plus permissif) |


### SSH & Accès

|                 | AWS                           | GCP                            |
| --------------- | ----------------------------- | ------------------------------ |
| Clé SSH         | Obligatoire (aws_key_pair)    | Optionnelle                    |
| SSH console     | EC2 Instance Connect (limité) | SSH natif dans le navigateur ✅ |
| User par défaut | ubuntu / ec2-user selon AMI   | ubuntu / compte Google         |

### Organisation des ressources

|              | AWS                                    | GCP                                          |
| ------------ | -------------------------------------- | -------------------------------------------- |
| Tags         | tags = { Name = "..." } (organisation) | labels = { env = "..." } (organisation)      |
| Network Tags | N/A                                    | tags = ["http-server"] (firewall uniquement) |


### Infrastructure minimale pour une VM

|                        | AWS                                              | GCP                                       |
| ---------------------- | ------------------------------------------------ | ----------------------------------------- |
| Ressources nécessaires | VPC + Subnet + IGW + Route Table + SG + Instance | Instance + Firewall                       |
| Complexité Terraform   | ⭐⭐⭐ Plus verbeux                                 | ⭐⭐ Plus simple                            |
| Philosophie            | Security-first (tout fermé)                      | Developer-friendly (default network prêt) |


**Conclusion** → AWS est plus verbeux mais plus explicite sur la sécurité. GCP est plus rapide à démarrer grâce au réseau default préconfigué. Les deux utilisent le même principe IaC avec Terraform ✅


## Connexion SSH

GCP a Cloud Shell & SSH dans le navigateur intégré directement dans la console — pas besoin de clé SSH, GCP en génère une temporaire automatiquement 

```text
Console GCP → Compute Engine → VM Instances
→ Colonne "Connect" → cliquer sur "SSH" ✅
```

AWS propose aussi EC2 Instance Connect mais c'est moins fluide.

Réseau par défaut
GCP crée automatiquement un réseau default avec des règles de firewall déjà configurées pour SSH (port 22) et HTTP (port 80)

```text
GCP par défaut ✅            AWS par défaut ❌
─────────────────            ─────────────────
VPC default existant    →    Pas de SG configuré
Firewall SSH ouvert     →    Tout bloqué
IP publique auto        →    Pas d'IP sans Elastic IP
SSH sans clé (console)  →    Clé obligatoire
```

Ce qu'il faut créer sur AWS vs GCP

| Ressource        | AWS (obligatoire) | GCP (optionnel)         |
| ---------------- | ----------------- | ----------------------- |
| VPC              | ✅ ou default      | default fourni          |
| Subnet           | ✅ obligatoire     | default fourni          |
| Security Group   | ✅ obligatoire     | firewall default        |
| Clé SSH          | ✅ obligatoire     | optionnel (console SSH) |
| IP publique      | ✅ access_config   | access_config           |
| Internet Gateway | ✅ obligatoire     | automatique             |


La philosophie des deux clouds
GCP → developer-friendly par défaut, tout fonctionne out of the box pour tester

AWS → security-first par défaut, tout est fermé, tu ouvres ce dont tu as besoin ✅

C'est un bon point à souligner aux stagiaires — AWS est plus verbeux en Terraform mais plus sécurisé par défaut en production !

- GCP et AWS ont le même principe :
- Sur AWS → aws_security_group

Sur GCP → google_compute_firewall
Dans les deux cas rien ne passe sans une règle explicite