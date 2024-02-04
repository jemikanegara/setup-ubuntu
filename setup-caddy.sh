#!/bin/bash

# Update the package lists
sudo apt-get update

# Install dependencies
sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl

# Add the official Caddy GPG key
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

# Add the repository to your sources list
echo "deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/caddy-stable.list

# Update the package lists with the new repository
sudo apt-get update

# Install Caddy
sudo apt-get install caddy

# Prompt user for domain and port
read -p "Enter your domain: " domain
read -p "Enter the port number for your local service: " port

# Set up Caddyfile
echo "$domain {
    reverse_proxy 127.0.0.1:$port
}" | sudo tee /etc/caddy/Caddyfile

# Format the Caddyfile
sudo caddy fmt --overwrite /etc/caddy/Caddyfile

# Start Caddy in the background
sudo caddy reload --config /etc/caddy/Caddyfile
