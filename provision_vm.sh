#!/bin/bash

# --- VARIABLES ---
resource_group="SvamparnasRG"
location="norwayeast"
vnet_name="SvampVNet"
subnet_name="SvampSubnet"
vm_web_name="BackendVM"
vm_proxy_name="FrontendProxyVM"

# --- SECRETS (GENERATED) ---
# Generate a strong random password for the database
DB_PASSWORD=$(openssl rand -base64 16)
# DuckDNS Token (Ideally this should be an input, but for this exercise we move it to a variable)
DUCKDNS_TOKEN="6ed97e8a-fe91-4986-b4da-3bfc75de29c2"

echo "Generated Database Password: $DB_PASSWORD"

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
echo "Preparing Database setup script..."
# Inject the generated password into the setup script
sed "s/PLACEHOLDER_DB_PASSWORD/$DB_PASSWORD/g" db_setup.sh > db_setup_final.sh

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
  --nsg-rule NONE \
  --custom-data @db_setup_final.sh

# 4. Fetch Database Private IP
echo "Fetching private IP for DatabaseVM..."
db_private_ip=$(az vm show -d -g $resource_group -n "DatabaseVM" --query privateIps -o tsv)
echo "Database Internal IP: $db_private_ip"

# 5. PREPARE BACKEND SCRIPT WITH DB HOST AND PASSWORD
echo "Preparing Backend setup script..."
cat <<EOF > app_setup_ready.sh
#!/bin/bash
export DB_HOST="$db_private_ip"
export DB_PASSWORD="$DB_PASSWORD"
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
  --nsg-rule NONE \
  --custom-data @app_setup_ready.sh

# 7. Fetch Backend Server PRIVATE IP (For internal connection)
echo "Fetching private IP for Backend..."
web_private_ip=$(az vm show -d -g $resource_group -n $vm_web_name --query privateIps -o tsv)

# 8. CREATE PROXY SCRIPT DYNAMICALLY
cat <<EOF > proxy_setup_ready.sh
#!/bin/bash
apt update
apt install nginx certbot python3-certbot-nginx -y

# Create DuckDNS update script
cat <<DUCK > /usr/local/bin/duckdns_update.sh
#!/bin/bash
curl "https://www.duckdns.org/update?domains=webinar-funtime-deluxe&token=$DUCKDNS_TOKEN&ip="
DUCK
chmod +x /usr/local/bin/duckdns_update.sh

# Run it once immediately
/usr/local/bin/duckdns_update.sh

# Setup Cron jobs
# 1. Update DuckDNS every 5 minutes
# 2. Renew Certbot every 12 hours
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/duckdns_update.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 */12 * * * certbot renew --quiet") | crontab -

cat <<NGINXCONF > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name webinar-funtime-deluxe.duckdns.org;
    location / {
        proxy_pass http://$web_private_ip;
        proxy_set_header Host \\$host;
        proxy_set_header X-Real-IP \\$remote_addr;
    }
}
NGINXCONF

systemctl restart nginx

# Request Certificate and redirect HTTP to HTTPS
certbot --nginx -d webinar-funtime-deluxe.duckdns.org --non-interactive --agree-tos --register-unsafely-without-email --redirect
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
  --nsg-rule NONE \
  --custom-data @proxy_setup_ready.sh

# 10. CREATE BASTION VM (WorkerVM2 -> bastionVM)
echo "Creating BastionVM (Debian 13)..."
az vm create \
  --resource-group $resource_group \
  --name "bastionVM" \
  --image "Debian:debian-13:13:latest" \
  --size standard_b2ats_v2 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name $vnet_name \
  --subnet $subnet_name \
  --public-ip-sku Standard
# Note: We allow default SSH (nsg-rule SSH) for the Bastion.

# 11. Open Ports
echo "Opening ports..."
# We ONLY open port 80 and 443 on the Proxy (The Bouncer)
az vm open-port --resource-group $resource_group --name $vm_proxy_name --port 80,443

# 12. Fetch PUBLIC IP addresses for the report
proxy_public_ip=$(az vm show -d -g $resource_group -n $vm_proxy_name --query publicIps -o tsv)
bastion_public_ip=$(az vm show -d -g $resource_group -n "bastionVM" --query publicIps -o tsv)

# Clean up temporary files
rm proxy_setup_ready.sh
rm app_setup_ready.sh
rm db_setup_final.sh

# --- FINAL REPORT ---
echo ""
echo "=================================================="
echo "DEPLOYMENT COMPLETE!"
echo "=================================================="
echo ""
echo "Here are your servers:"
echo "Bastion Public IP: $bastion_public_ip (SSH Entry Point)"
echo "Proxy Public IP:   $proxy_public_ip (Web Access)"
echo "Database & Backend: Protected (Access via Bastion only)"
echo "Database Password:  $DB_PASSWORD"
az vm list-ip-addresses -g $resource_group -o table
