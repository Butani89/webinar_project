#!/bin/bash
set -e

# --- VARIABLES ---
RESOURCE_GROUP="SvamparnasRG_Prod"
LOCATION="norwayeast"

# --- SECRETS ---
# Generate a strong random password for the database
DB_PASSWORD=$(openssl rand -base64 16)
# DuckDNS Token (Ideally this should be an input)
DUCKDNS_TOKEN="6ed97e8a-fe91-4986-b4da-3bfc75de29c2"

echo "Generated Database Password: $DB_PASSWORD"

# Ensure SSH keys exist
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "SSH key not found. Generating..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

# Create Resource Group
echo "Creating resource group $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Deploy using Bicep
echo "Deploying infrastructure with Bicep..."
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file infra/main.bicep \
  --parameters adminPublicKey="$SSH_KEY" \
  --parameters dbPassword="$DB_PASSWORD" \
  --parameters duckDnsToken="$DUCKDNS_TOKEN" \
  --output table

echo ""
echo "=================================================="
echo "DEPLOYMENT INITIATED"
echo "=================================================="
echo "Wait for the VMs to finish provisioning (cloud-init)..."
echo "You can check progress in the Azure Portal."
echo ""
echo "Database Password: $DB_PASSWORD"
