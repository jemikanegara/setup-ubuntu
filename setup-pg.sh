#!/bin/bash

# Prompt for PostgreSQL version (default is 14)
read -p "Enter PostgreSQL version [14]: " PG_VERSION
PG_VERSION=${PG_VERSION:-14}

# Prompt for port number (default is 5432)
read -p "Enter port number [5432]: " PG_PORT
PG_PORT=${PG_PORT:-5432}

# Prompt for new superuser (default is 'myuser')
read -p "Enter new superuser [myuser]: " PG_USER
PG_USER=${PG_USER:-myuser}

# Prompt for new superuser's password (default is 'mypassword')
read -p "Enter new superuser's password [mypassword]: " PG_PASSWORD
PG_PASSWORD=${PG_PASSWORD:-mypassword}

# Prompt for new database name (default is 'mydatabase')
read -p "Enter new database name [mydatabase]: " PG_DB
PG_DB=${PG_DB:-mydatabase}

# Update package lists
sudo apt-get update

# Install PostgreSQL
sudo apt-get install -y postgresql-$PG_VERSION postgresql-contrib-$PG_VERSION

# Backup the original configuration file
sudo cp /etc/postgresql/$PG_VERSION/main/postgresql.conf /etc/postgresql/$PG_VERSION/main/postgresql.conf.bak

# Change listen_addresses and port in the configuration file
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/$PG_VERSION/main/postgresql.conf
sudo sed -i "s/#port = 5432/port = $PG_PORT/" /etc/postgresql/$PG_VERSION/main/postgresql.conf

# Allow all connections in pg_hba.conf
echo "host    all             all             0.0.0.0/0            scram-sha-256" | sudo tee -a /etc/postgresql/$PG_VERSION/main/pg_hba.conf

# Restart PostgreSQL service to apply changes
sudo service postgresql restart

# Allow incoming connections to the chosen port
sudo ufw allow $PG_PORT/tcp

# Create a new superuser
sudo -u postgres psql -c "CREATE USER $PG_USER WITH SUPERUSER PASSWORD '$PG_PASSWORD';"

# Create a new database owned by the new superuser
sudo -u postgres psql -c "CREATE DATABASE $PG_DB OWNER $PG_USER;"

echo "PostgreSQL has been configured to listen on port $PG_PORT."
