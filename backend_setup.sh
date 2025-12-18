#!/bin/bash

# 1. Update and Install
apt update
apt install nginx git python3-full python3-pip python3-venv -y

# 2. Get Website Files
rm -rf /var/www/html/*
git clone https://github.com/Butani89/webinar_project.git /var/www/html/

# 3. Setup Python Virtual Environment & Dependencies
cd /var/www/html
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 4. Setup Python App Service
# We expect DB_HOST to be set in the environment or passed to this script.
# If not set, it defaults to localhost in the app code, but we want to inject it here.
# The provision_vm.sh will likely prepend "export DB_HOST=..." before running this.

cat <<EOF > /etc/systemd/system/webinar.service
[Unit]
Description=Webinar Python App
After=network.target

[Service]
User=root
WorkingDirectory=/var/www/html
Environment="DB_HOST=${DB_HOST:-localhost}"
Environment="DB_PASSWORD=${DB_PASSWORD}"
ExecStart=/var/www/html/venv/bin/python3 app.py
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
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

systemctl restart nginx