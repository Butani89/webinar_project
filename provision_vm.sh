#!/bin/bash

# --- VARIABLES ---
resource_group="SvamparnasRG"
location="norwayeast"
vnet_name="SvampVNet"
subnet_name="SvampSubnet"
vm_web_name="BackendVM"
vm_proxy_name="FrontendProxyVM"

# 1. Create Resource Group
echo "Creating resource group..."
az group create --name $resource_group --location $location

# 2. Create Network
echo "Creating virtual network..."
az network vnet create \
  --resource-group $resource_group \
  --name $vnet_name \
  --address-prefix 10.0.0.0/16 \
  --subnet-name $subnet_name \
  --subnet-prefix 10.0.1.0/24

# 3. CREATE DATABASE VM (WorkerVM1 -> DatabaseVM)
echo "Creating DatabaseVM (Debian 13)..."
az vm create \
  --resource-group $resource_group \
  --name "DatabaseVM" \
  --image "Debian:debian-13:13:latest" \
  --size standard_b2ats_v2 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name $vnet_name \
  --subnet $subnet_name \
  --public-ip-sku Standard \
  --custom-data @db_setup.sh

# 4. Fetch Database Private IP
echo "Fetching private IP for DatabaseVM..."
db_private_ip=$(az vm show -d -g $resource_group -n "DatabaseVM" --query privateIps -o tsv)
echo "Database Internal IP: $db_private_ip"

# 5. PREPARE BACKEND SCRIPT WITH DB HOST
echo "Preparing Backend setup script..."
cat <<EOF > app_setup_ready.sh
#!/bin/bash
export DB_HOST="$db_private_ip"
EOF
# Append the original backend setup script content
cat backend_setup.sh >> app_setup_ready.sh

# 6. CREATE BACKEND (Web Server)
echo "Creating Backend server (App)..."
az vm create \
  --resource-group $resource_group \
  --name $vm_web_name \
  --image Ubuntu2404 \
  --size standard_b2ats_v2 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name $vnet_name \
  --subnet $subnet_name \
  --public-ip-sku Standard \
  --custom-data @app_setup_ready.sh

# 7. Fetch Backend Server PRIVATE IP (For internal connection)
echo "Fetching private IP for Backend..."
web_private_ip=$(az vm show -d -g $resource_group -n $vm_web_name --query privateIps -o tsv)

# 8. CREATE PROXY SCRIPT DYNAMICALLY
cat <<EOF > proxy_setup_ready.sh
#!/bin/bash
apt update
apt install nginx -y

cat <<NGINXCONF > /etc/nginx/sites-available/default
server {
    listen 80;
    location / {
        proxy_pass http://$web_private_ip;
        proxy_set_header Host \\\$host;
        proxy_set_header X-Real-IP \\\$remote_addr;
    }
}
NGINXCONF

systemctl restart nginx
EOF

# 9. CREATE FRONTEND (Reverse Proxy)
echo "Creating Proxy server..."
az vm create \
  --resource-group $resource_group \
  --name $vm_proxy_name \
  --image Ubuntu2404 \
  --size standard_b2ats_v2 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name $vnet_name \
  --subnet $subnet_name \
  --public-ip-sku Standard \
  --custom-data @proxy_setup_ready.sh

# 10. CREATE EXTRA WORKER (WorkerVM2)
echo "Creating WorkerVM2 (Debian 13)..."
az vm create \
  --resource-group $resource_group \
  --name "WorkerVM2" \
  --image "Debian:debian-13:13:latest" \
  --size standard_b2ats_v2 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name $vnet_name \
  --subnet $subnet_name \
  --public-ip-sku Standard

# 11. Open Ports
echo "Opening ports..."
# We ONLY open port 80 on the Proxy (The Bouncer)
az vm open-port --resource-group $resource_group --name $vm_proxy_name --port 80

# 12. Fetch PUBLIC IP addresses for the report
proxy_public_ip=$(az vm show -d -g $resource_group -n $vm_proxy_name --query publicIps -o tsv)
backend_public_ip=$(az vm show -d -g $resource_group -n $vm_web_name --query publicIps -o tsv)
db_public_ip=$(az vm show -d -g $resource_group -n "DatabaseVM" --query publicIps -o tsv)
worker2_public_ip=$(az vm show -d -g $resource_group -n "WorkerVM2" --query publicIps -o tsv)

# Clean up temporary files
rm proxy_setup_ready.sh
rm app_setup_ready.sh

# --- FINAL REPORT ---
echo ""
echo "=================================================="
echo "DEPLOYMENT COMPLETE!"
echo "=================================================="
echo ""
echo "Here are your servers:"
echo "Proxy Public IP:   $proxy_public_ip"
echo "Backend Public IP: $backend_public_ip"
echo "Database Public IP:$db_public_ip"
echo "Worker2 Public IP: $worker2_public_ip"
az vm list-ip-addresses -g $resource_group -o table