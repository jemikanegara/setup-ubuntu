#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt-get update

# Install Redis
echo "Installing Redis..."
sudo apt-get install redis-server -y

# Start Redis
echo "Starting Redis..."
sudo systemctl enable redis-server.service

# Prompt for password
read -p "Enter your Redis password (press enter to skip): " password

# Configure Redis with the provided password, if one was entered
if [ -n "$password" ]; then
    echo "Configuring Redis with your password..."
    echo -e "requirepass $password\n" | sudo tee -a /etc/redis/redis.conf > /dev/null
fi

# Prompt for port
read -p "Enter your Redis port (default is 6379): " port

# Use default port if one was not entered
if [ -z "$port" ]; then
    port=6379
fi

# Configure Redis with the provided port
echo "Configuring Redis with your port..."
echo -e "port $port\n" | sudo tee -a /etc/redis/redis.conf > /dev/null

# Prompt to expose port
read -p "Do you want to expose the port to the outside? (Y/n, default is Y): " expose_port

# Use default value if one was not entered
if [ -z "$expose_port" ]; then
    expose_port=Y
fi

# If expose_port is Y, bind Redis to 0.0.0.0 and allow incoming traffic on the Redis port
if [ "$expose_port" = Y ] || [ "$expose_port" = y ]; then
    echo "Binding Redis to 0.0.0.0..."
    echo -e "bind 0.0.0.0\n" | sudo tee -a /etc/redis/redis.conf > /dev/null

    echo "Allowing incoming traffic on port $port..."
    sudo ufw allow $port
fi

# Restart Redis to apply changes
echo "Restarting Redis to apply changes..."
sudo systemctl restart redis-server.service

echo "Redis installation and configuration complete!"
