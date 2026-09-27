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


