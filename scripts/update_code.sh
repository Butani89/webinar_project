#!/bin/bash

# Configuration
BASTION_IP="4.235.110.229"  # The current Bastion IP (from your deployment)
BACKEND_IP="10.0.1.4"       # The current Backend Internal IP

echo "============================================="
echo "   Updating Application Code on BackendVM    "
echo "============================================="
echo "Bastion Host: $BASTION_IP"
echo "Target Host:  $BACKEND_IP"
echo "---------------------------------------------"

# Check if SSH key exists
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Error: SSH Private key (~/.ssh/id_rsa) not found!"
    exit 1
fi

echo "Connecting via Bastion..."
ssh -o StrictHostKeyChecking=no -J azureuser@$BASTION_IP azureuser@$BACKEND_IP << 'EOF'
    set -e
    echo ">> Connected to BackendVM."
    
    cd /var/www/html
    
    echo ">> Fetching latest code from GitHub..."
    sudo git fetch --all
    sudo git reset --hard origin/main
    
    echo ">> Installing dependencies..."
    source venv/bin/activate
    pip install -r requirements.txt
    
    echo ">> Building frontend..."
    cd frontend
    sudo npm install
    sudo npm run build
    cd ..
    
    echo ">> Running migrations..."
    cd backend
    python manage.py migrate --noinput
    python manage.py collectstatic --noinput
    cd ..
    
    echo ">> Restarting Application Service..."
    sudo systemctl restart webinar
    sudo systemctl restart nginx
    
    echo ">> Done!"
EOF

echo "============================================="
echo "   Update Complete!                          "
echo "============================================="
