#!/bin/bash

# 1. Update and Install Dependencies
apt update
apt install nginx git python3-full python3-pip python3-venv curl -y

# Install Node.js for Vue build
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# 2. Get Website Files
sudo chown -R azureuser:azureuser /var/www/html
if [ -d "/var/www/html/.git" ]; then
  cd /var/www/html
  git fetch --all
  git reset --hard origin/main
else
  sudo rm -rf /var/www/html/*
  git clone https://github.com/Butani89/webinar_project.git /var/www/html/
fi

# 3. Setup Python Virtual Environment
cd /var/www/html
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 4. Build Frontend (Vue + Tailwind)
cd /var/www/html/frontend
npm install
npm run build

# 5. Setup Django
cd /var/www/html/backend
python manage.py migrate --noinput
python manage.py collectstatic --noinput

# 6. Setup Systemd Service for Django (Gunicorn)
cat <<EOF > /etc/systemd/system/webinar.service
[Unit]
Description=Webinar Django App
After=network.target

[Service]
User=root
WorkingDirectory=/var/www/html/backend
Environment="DB_HOST=${DB_HOST:-localhost}"
Environment="DB_PASSWORD=${DB_PASSWORD}"
Environment="ADMIN_PASSWORD=${ADMIN_PASSWORD}"
Environment="DJANGO_SETTINGS_MODULE=core.settings"
ExecStart=/var/www/html/venv/bin/gunicorn --workers 3 --bind 127.0.0.1:8000 core.wsgi:application
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start webinar
systemctl enable webinar

# 7. Configure Nginx
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    
    # Serve Vue build output
    location / {
        root /var/www/html/app/static;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    # Django API
    location /api/ {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Django Media (Mushroom Art)
    location /media/ {
        alias /var/www/html/backend/media/;
    }

    # Django Admin
    location /admin/ {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
    }
}
EOF

systemctl restart nginx
