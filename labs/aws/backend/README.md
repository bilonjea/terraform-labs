# Pourquoi un backend distant ?
❌ Backend LOCAL (défaut)
   terraform.tfstate → sur ta machine
   → Impossible de travailler en équipe
   → Perdu si ta machine crash

✅ Backend DISTANT (S3)
   terraform.tfstate → dans S3 (partagé, sécurisé, versionné)
   → Toute l'équipe accède au même state
   → Verrou anti-conflit (locking)

## Ce qu'on va créer
┌─────────────────────────────────┐
│           AWS                   │
│                                 │
│  ┌──────────────┐               │
│  │  S3 Bucket   │ ← tfstate     │
│  │  (chiffré)   │               │
│  │  (versionné) │               │
│  └──────────────┘               │
│                                 │
│  ┌──────────────┐               │
│  │  DynamoDB    │ ← locking     │
│  │  (LockID)    │               │
│  └──────────────┘               │
└─────────────────────────────────┘


S3 Bucket : formation-tfv-tfstate-2026/
    ├── dev/terraform.tfstate    ← state DEV
    ├── staging/terraform.tfstate
    └── prod/terraform.tfstate   ← state PROD


 ##Les commandes clés

# 1. Déployer le bootstrap (une seule fois)
cd bootstrap/
terraform init && terraform apply

# 2. Initialiser ton projet avec le backend distant
cd ../mon-projet/
terraform init
# → "Successfully configured the backend S3" ✅

# 3. Migrer un state local existant vers S3
terraform init -migrate-state
# → "Do you want to copy existing state?" → yes ✅

# 4. Vérifier où est stocké le state
terraform state list


terraform-remote-backend/
├── bootstrap/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── projet-principal/
    ├── modules/ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── env/
        ├── dev/
        │   ├── backend.tf
        │   ├── main.tf
        │   ├── variables.tf
        │   └── outputs.tf
        └── prod/
            ├── backend.tf
            ├── main.tf
            ├── variables.tf
            └── outputs.tf


# 1️⃣ Bootstrap — UNE SEULE FOIS
cd bootstrap/
terraform init && terraform apply

# 2️⃣ DEV — Ubuntu 26.04
cd ../projet-principal/env/dev/
terraform init          # → "Backend initialized (S3)" ✅
terraform plan
terraform apply
# → output : ssh -i ~/.ssh/id_rsa_formation ubuntu@<IP>

# 3️⃣ PROD — Amazon Linux 2023
cd ../prod/
terraform init          # → state isolé prod/terraform.tfstate
terraform plan
terraform apply
# → output : ssh -i ~/.ssh/id_rsa_formation ec2-user@<IP>


| Env  | AMI ID                | OS                      | User SSH |
| ---- | --------------------- | ----------------------- | -------- |
| DEV  | ami-091138d0f0d41ff90 | Ubuntu 26.04 LTS        | ubuntu   |
| PROD | ami-0236922087fa98b6e | Amazon Linux 2023 k-6.1 | ec2-user |