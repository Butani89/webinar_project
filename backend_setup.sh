#!/bin/bash

# 1. Update and install system tools
apt-get update -y
apt-get install -y python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx git

# 2. Install Python libraries (Includes Gunicorn now!)
pip3 install flask flask-cors psycopg2-binary gunicorn

# 3. Setup Database (PostgreSQL)
# Switch to postgres user and create DB and User
sudo -u postgres psql -c "CREATE DATABASE webinar_db;"
sudo -u postgres psql -c "CREATE USER adminuser WITH PASSWORD 'Password123!';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE webinar_db TO adminuser;"

# 4. Create the Python App (app.py)
# We write the code directly to a file
cat <<EOF > /home/azureuser/app.py
from flask import Flask, request, jsonify
import psycopg2
from flask_cors import CORS

app = Flask(__name__)
CORS(app) # Allows the website to communicate with the server

# Database settings
DB_CONFIG = {
    'dbname': 'webinar_db',
    'user': 'adminuser',
    'password': 'Password123!',
    'host': 'localhost'
}

# Function to create the table if it is missing
def init_db():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        cur.execute("""
            CREATE TABLE IF NOT EXISTS attendees (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100),
                email VARCHAR(100),
                company VARCHAR(100),
                jobtitle VARCHAR(100)
            );
        """)
        conn.commit()
        cur.close()
        conn.close()
        print("Database and table are ready!")
    except Exception as e:
        print(f"Error starting database: {e}")

# Runs when the server starts
init_db()

@app.route('/register', methods=['POST'])
def register():
    data = request.json
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        # Save data to the table
        cur.execute(
            "INSERT INTO attendees (name, email, company, jobtitle) VALUES (%s, %s, %s, %s)",
            (data['name'], data['email'], data['company'], data['jobtitle'])
        )
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"message": "Success"}), 200
    except Exception as e:
        print(e)
        return jsonify({"message": "Error"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# 5. Create Systemd Service (To keep app running)
# THIS IS CHANGED TO USE GUNICORN
cat <<EOF > /etc/systemd/system/webinar.service
[Unit]
Description=Gunicorn instance to serve webinar app
After=network.target

[Service]
User=azureuser
Group=azureuser
WorkingDirectory=/home/azureuser
Environment="PATH=/usr/local/bin:/usr/bin"
# Executing Gunicorn instead of python
# --workers 3: Good for small VMs
# --bind 0.0.0.0:5000: Listen on port 5000
ExecStart=/usr/local/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 app:app

[Install]
WantedBy=multi-user.target
EOF

# 6. Start the Service
systemctl daemon-reload
systemctl start webinar
systemctl enable webinar

# 7. Configure Nginx (Web Server) for Backend
# (Yes, we use Nginx on backend too, to act as a buffer or handle static files if needed later)
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

systemctl restart nginx
