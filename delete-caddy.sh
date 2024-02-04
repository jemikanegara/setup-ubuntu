# Stop Caddy if it's running
sudo pkill caddy

# Uninstall Caddy
sudo apt-get purge caddy

# Remove the Caddyfile
sudo rm /etc/caddy/Caddyfile

# Remove the Caddy repository from your sources list
sudo rm /etc/apt/sources.list.d/caddy-stable.list

# Update the package lists to reflect the removed repository
sudo apt-get update
