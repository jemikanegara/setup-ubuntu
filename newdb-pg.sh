#!/bin/bash

# Prompt for new superuser (default is 'myuser')
read -p "Enter new superuser [myuser]: " PG_USER
PG_USER=${PG_USER:-myuser}

# Prompt for new superuser's password (default is 'mypassword')
read -p "Enter new superuser's password [mypassword]: " PG_PASSWORD
PG_PASSWORD=${PG_PASSWORD:-mypassword}

# Prompt for new database name (default is 'mydatabase')
read -p "Enter new database name [mydatabase]: " PG_DB
PG_DB=${PG_DB:-mydatabase}

# Create a new superuser
sudo -u postgres psql -c "CREATE USER $PG_USER WITH SUPERUSER PASSWORD '$PG_PASSWORD';"

# Create a new database owned by the new superuser
sudo -u postgres psql -c "CREATE DATABASE $PG_DB OWNER $PG_USER;"

echo "A new PostgreSQL user ($PG_USER) and database ($PG_DB) have been created."
