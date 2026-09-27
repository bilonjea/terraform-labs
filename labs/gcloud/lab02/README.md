# Injection de clé ssh et install de ngnix

metadata_startup_script — l'équivalent GCP du user_data AWS 


|                  | AWS                     | GCP                                  |
| ---------------- | ----------------------- | ------------------------------------ |
| Clé SSH          | aws_key_pair + key_name | metadata = { ssh-keys = "user:clé" } |
| Script démarrage | user_data               | metadata_startup_script              |
