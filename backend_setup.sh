#!/bin/bash

# 1. Update and Install
apt update
apt install nginx git python3-full libpq-dev postgresql postgresql-contrib python3-flask python3-psycopg2 python3-flask-cors -y

# 2. Setup Database
systemctl start postgresql
systemctl enable postgresql
sudo -u postgres psql -c "CREATE USER adminuser WITH PASSWORD 'Password123!';"
sudo -u postgres psql -c "CREATE DATABASE webinar_db OWNER adminuser;"

# 3. Get Website Files
rm -rf /var/www/html/*
git clone https://github.com/Butani89/webinar_project.git /tmp/website_files
cp -r /tmp/website_files/* /var/www/html/

# 4. Setup Python App Service
cat <<EOF > /etc/systemd/system/webinar.service
[Unit]
Description=Webinar Python App
After=network.target

[Service]
User=root
WorkingDirectory=/var/www/html
ExecStart=/usr/bin/python3 app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start webinar
systemctl enable webinar

# 5. Configure Local Nginx (Backend)
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    location / {
        root /var/www/html;
        index index.html;
        try_files \$uri \$uri/ =404;
    }
    location /api/ {
        proxy_pass http://127.0.0.1:5000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

systemctl restart nginx
