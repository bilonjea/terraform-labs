# Injection de clé ssh et install de ngnix

metadata_startup_script — l'équivalent GCP du user_data AWS 


|                  | AWS                     | GCP                                  |
| ---------------- | ----------------------- | ------------------------------------ |
| Clé SSH          | aws_key_pair + key_name | metadata = { ssh-keys = "user:clé" } |
| Script démarrage | user_data               | metadata_startup_script              |


# La différence GCP vs AWS ici

|                         | AWS                             | GCP                                 |
| ----------------------- | ------------------------------- | ----------------------------------- |
| User custom             | user_data bash script           | metadata_startup_script bash script |
| Clé SSH user par défaut | aws_key_pair + key_name         | metadata = { ssh-keys = "..." }     |
| Désactiver user défaut  | usermod -s /sbin/nologin ubuntu | Identique ✅                         |

Le script bash est exactement le même sur les deux clouds — seul le bloc Terraform qui l'appelle change