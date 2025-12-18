#!/bin/bash
apt update
apt install nginx certbot python3-certbot-nginx -y

# Create DuckDNS update script
cat <<DUCK > /usr/local/bin/duckdns_update.sh
#!/bin/bash
curl "https://www.duckdns.org/update?domains=webinar-funtime-deluxe&token=__DUCKDNS_TOKEN__&ip="
DUCK
chmod +x /usr/local/bin/duckdns_update.sh

# Run it once immediately
/usr/local/bin/duckdns_update.sh

# WAIT for DNS propagation (Essential for Certbot validation)
echo "Waiting 60 seconds for DNS propagation..."
sleep 60

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
        proxy_pass http://__BACKEND_IP__;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
NGINXCONF

systemctl restart nginx

# Request Certificate and redirect HTTP to HTTPS with Retry Logic
for i in {1..5}; do
  echo "Attempt $i to obtain SSL certificate..."
  certbot --nginx -d webinar-funtime-deluxe.duckdns.org --non-interactive --agree-tos --register-unsafely-without-email --redirect && break
  echo "Certbot failed, retrying in 30s..."
  sleep 30
done
