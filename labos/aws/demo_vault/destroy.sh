#!/bin/bash
set -e

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='myroot'

export AWS_ACCESS_KEY_ID=$(vault kv get -field=AWS_ACCESS_KEY_ID secret/aws)
export AWS_SECRET_ACCESS_KEY=$(vault kv get -field=AWS_SECRET_ACCESS_KEY secret/aws)
export AWS_DEFAULT_REGION=$(vault kv get -field=AWS_DEFAULT_REGION secret/aws)

rm -f public_ip.txt

echo "Destroying Terraform..."
terraform destroy -auto-approve

echo "Destruction terminée."