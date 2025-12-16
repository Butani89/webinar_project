#!/bin/bash

# --- VARIABLES ---
# ORIGINAL SETTINGS
resource_group="SvamparnasRG"
location="norwayeast"
vnet_name="SvampVNet"
subnet_name="SvampSubnet"
vm_web_name="BackendVM"
vm_proxy_name="FrontendProxyVM"

# Your hardware choice
vm_size="standard_b2ats_v2"

# 1. Create Resource Group
echo "Creating resource group in $location..."
az group create --name $resource_group --location $location

# 2. Create Network
echo "Creating virtual network..."
az network vnet create \
  --resource-group $resource_group \
  --name $vnet_name \
  --address-prefix 10.0.0.0/16 \
  --subnet-name $subnet_name \
  --subnet-prefix 10.0.1.0/24

# 3. CREATE BACKEND (Web Server)
# This sends backend_setup.sh (with Gunicorn) to the server
echo "Creating Backend server ($vm_size)..."
az vm create \
  --resource-group $resource_group \
  --name $vm_web_name \
  --image Ubuntu2404 \
  --size $vm_size \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name $vnet_name \
  --subnet $subnet_name \
  --public-ip-sku Standard \
  --custom-data @backend_setup.sh

# 4. Fetch Backend Server PRIVATE IP
echo "Fetching private IP for Backend..."
web_private_ip=$(az vm show -d -g $resource_group -n $vm_web_name --query privateIps -o tsv)

# 5. CREATE PROXY SCRIPT DYNAMICALLY
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

# 6. CREATE FRONTEND (Reverse Proxy)
echo "Creating Proxy server ($vm_size)..."
az vm create \
  --resource-group $resource_group \
  --name $vm_proxy_name \
  --image Ubuntu2404 \
  --size $vm_size \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name $vnet_name \
  --subnet $subnet_name \
  --public-ip-sku Standard \
  --custom-data @proxy_setup_ready.sh

# 7. Open Ports
echo "Opening ports..."
# Only open port 80 on Proxy
az vm open-port --resource-group $resource_group --name $vm_proxy_name --port 80

# 8. Fetch IP addresses for report
proxy_public_ip=$(az vm show -d -g $resource_group -n $vm_proxy_name --query publicIps -o tsv)
backend_public_ip=$(az vm show -d -g $resource_group -n $vm_web_name --query publicIps -o tsv)

# Cleanup
rm proxy_setup_ready.sh

# --- FINAL REPORT ---
echo ""
echo "=================================================="
echo "DEPLOYMENT COMPLETE! 🍄"
echo "=================================================="
echo ""
echo "Region: $location"
echo "Size:   $vm_size"
echo ""
echo "Here are your connection details:"
echo "--------------------------------------------------"
echo "1. PROXY (FRONTEND) - The website is here:"
echo "   http://$proxy_public_ip"
echo ""
echo "2. BACKEND (WEBSERVER) - Internal Only:"
echo "   http://$backend_public_ip (Should not work publicly)"
echo ""
echo "   Admin Login (SSH):"
echo "   ssh azureuser@$backend_public_ip"
echo "--------------------------------------------------"

