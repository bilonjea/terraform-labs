# Gestion des variables 

type de variables :

- string
- number
- bool (boolean)
- liste
- map


## déclarations

```text
variable "ma_variable" {}    ** terraform demande de saisir la valeur **

variable "ma_variable_bool" {
    type = "bool"
    default = true
}



variable "ma_variable_map" {
    type = "map"
    default = {
        "key-"="value-1"
        "key-2"="value-2"
        "key-3"="value-3"
    }
}

variable "host" {
    type = "list"
    default = ["127.0.0.1 localhost ", "192.168.1.133 gitlab.test"]
}

```


## deux maniière d'utiliser la variable 

```text
output "out_put_1_ma_variable" {
    value = var.ma_variable

}    

output "out_put_2_ma_variable" {
    value = "${var.ma_variable}"
}
```





# priorité des variables

---
1. Variables d'environnement  : **export TF_VAR_nom_de_la_variable="valeur"**
2. Fichier : terraform.tfvars 
3. Fichier json : terraform.tfvars.json
4. Fichier *.auto.tfvars ou  *.auto.tfvars.json
5. CLI : -var ou -var-file
   ```bash
   terraform apply -var 'ma_variable="ma_valeur"'
   ```
6. CLI : -var-file
```bash
   terraform apply -var 'ma_variable="ma_valeur"' -var-file varfile.tfvars
```



**Générer ta clé SSH (si pas déjà fait)**
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_formation
# Crée deux fichiers :
# ~/.ssh/id_rsa_formation      ← clé privée (garde la précieusement !)
# ~/.ssh/id_rsa_formation.pub  ← clé publique (à partager)
```

**Le user par défaut dépend de l'AMI**

| AMI              | User par défaut |
| ---------------- | --------------- |
| Amazon Linux     | ec2-user        |
| Ubuntu           | ubuntu          |
| RHEL / AlmaLinux | ec2-user        |
| Debian           | admin           |



```bash
scp welcome-professeur.html formateur@<IP>:/var/www/html/index.html


# ✅ Copier dans le home d'ubuntu (pas besoin de droits root)
scp welcome-professeur.html ubuntu@44.204.93.221:~/index.html


# ✅ Se connecter et déplacer le fichier avec sudo
ssh ubuntu@44.204.93.221 \
  "sudo mv ~/index.html /var/www/html/index.html"
```
 

 



