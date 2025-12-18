#!/bin/bash

# 1. Update and Install
apt update
apt install postgresql postgresql-contrib -y

# 2. Configure PostgreSQL to listen on all interfaces
# Find the config file path (usually /etc/postgresql/15/main/postgresql.conf or similar depending on version)
# We use a wildcard to catch the version number
CONF_DIR=$(find /etc/postgresql -name main -type d | head -n 1)

if [ -z "$CONF_DIR" ]; then
    echo "PostgreSQL configuration directory not found!"
    exit 1
fi

echo "Configuring PostgreSQL in $CONF_DIR..."

# Listen on all addresses
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$CONF_DIR/postgresql.conf"

# Allow access from the VNet (10.0.0.0/16)
echo "host    all             all             10.0.0.0/16             scram-sha-256" >> "$CONF_DIR/pg_hba.conf"

# 3. Setup Database and User
systemctl restart postgresql
systemctl enable postgresql

sudo -u postgres psql -c "CREATE USER adminuser WITH PASSWORD 'PLACEHOLDER_DB_PASSWORD';"
sudo -u postgres psql -c "CREATE DATABASE webinar_db OWNER adminuser;"

echo "Database setup complete."
