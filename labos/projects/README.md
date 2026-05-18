# Exemple de structure terraform pour un developpement optimal


**Risque sans structures**
- manque de documentations
- non separation des env
- code dupliquer
- mauvaise gestions des fichies terraform state


- L'architecture optimale d'un dossier Terraform (environments, modules, scripts).
- Les bonnes pratiques pour séparer les environnements, réutiliser du code avec des modules, et automatiser les déploiements.
- Des outils essentiels comme TFLint, Checkov, et Terragrunt pour valider et sécuriser votre code.
- Des conseils pratiques pour documenter votre projet et collaborer en équipe.

**Bonne pratiques**

- versioner les modules git tag ou terraform registry
- utiliser les backend distant pour stocker les terraform state (buckets s3, terraform cloud etc)
- automatiser les deploiement avec pipeline de CICD pour valider et appliquer les changements
- utiliser les merge request avant d'accepter les changements sur branch main ou master
- validation du code 
  - terraform validate
  - terraform plan
  - TFLint, Checkov, et Terragrunt pour valider et sécuriser votre code
- documenter chaque composants pour faciliter la collaboration

