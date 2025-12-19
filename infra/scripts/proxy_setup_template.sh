#!/bin/bash
apt update
apt install nginx certbot python3-certbot-nginx cron curl -y

# Install Azure CLI (for interacting with Storage)
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Login with Managed Identity
az login --identity

STORAGE_ACCOUNT="__STORAGE_ACCOUNT_NAME__"
CONTAINER="certs"
ARCHIVE="letsencrypt.tar.gz"

echo "Checking for existing certificates in $STORAGE_ACCOUNT..."

# Try to download existing certs
if az storage blob exists --account-name $STORAGE_ACCOUNT --container-name $CONTAINER --name $ARCHIVE --auth-mode login --output tsv --query exists | grep -q "true"; then
    echo "Restoring certificates from storage..."
    az storage blob download --account-name $STORAGE_ACCOUNT --container-name $CONTAINER --name $ARCHIVE --file /tmp/$ARCHIVE --auth-mode login
    tar -xzf /tmp/$ARCHIVE -C /
    echo "Certificates restored."
else
    echo "No existing certificates found. Generating new ones..."
fi

# Create DuckDNS update script
cat <<DUCK > /usr/local/bin/duckdns_update.sh
#!/bin/bash
curl "https://www.duckdns.org/update?domains=webinar-deluxe&token=__DUCKDNS_TOKEN__&ip="
DUCK
chmod +x /usr/local/bin/duckdns_update.sh

# Run it once immediately
/usr/local/bin/duckdns_update.sh

# WAIT for DNS propagation (Essential for Certbot validation)
echo "Waiting 60 seconds for DNS propagation..."
sleep 60

cat <<NGINXCONF > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name webinar-deluxe.duckdns.org;
    location / {
        proxy_pass http://__BACKEND_IP__;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
NGINXCONF

systemctl restart nginx

# Create a backup script for renewal hooks
cat <<BACKUP > /usr/local/bin/backup_certs.sh
#!/bin/bash
echo "Backing up certificates to Azure Storage..."
tar -czf /tmp/$ARCHIVE /etc/letsencrypt
az login --identity --output none # Ensure we are logged in
az storage blob upload --account-name $STORAGE_ACCOUNT --container-name $CONTAINER --name $ARCHIVE --file /tmp/$ARCHIVE --auth-mode login --overwrite
BACKUP
chmod +x /usr/local/bin/backup_certs.sh

# Only run Certbot if we didn't restore a working config (or check if live dir exists)
if [ ! -d "/etc/letsencrypt/live/webinar-deluxe.duckdns.org" ]; then
    # Request Certificate and redirect HTTP to HTTPS with Retry Logic
    for i in {1..5}; do
      echo "Attempt $i to obtain SSL certificate..."
      # Add --deploy-hook to back up immediately after success
      certbot --nginx -d webinar-deluxe.duckdns.org --non-interactive --agree-tos --register-unsafely-without-email --redirect --deploy-hook /usr/local/bin/backup_certs.sh && break
      echo "Certbot failed, retrying in 30s..."
      sleep 30
    done
else
    echo "Certificates already exist on disk (restored). Configuring Nginx to use them..."
    # If we restored, we might need to reinstall the Nginx certificate configuration if it wasn't captured in sites-available
    # (Note: /etc/letsencrypt contains the certs, but /etc/nginx/sites-available/default also needs the SSL config lines)
    # Certbot --reinstall can help, or we can just run certbot again, it should detect existing certs and just install the nginx config.
    certbot install --nginx -d webinar-deluxe.duckdns.org --non-interactive --redirect
fi

# Setup Cron jobs
# 1. Update DuckDNS every 5 minutes
# 2. Renew Certbot every 12 hours (Certbot adds its own cron, but we added a deploy-hook above for new certs.
#    For renewals, we can rely on Certbot's standard hook mechanism if we add it to cli.ini or just force it here).
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/duckdns_update.sh") | crontab -
# Ensure renewal also triggers backup. Certbot keeps config in /etc/letsencrypt/renewal/*.conf.
# We will add a post-hook to the renewal config globally.
echo "deploy-hook = /usr/local/bin/backup_certs.sh" >> /etc/letsencrypt/cli.ini

