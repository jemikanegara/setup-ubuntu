#!/bin/bash

# Prompt for new FTP user (default is 'ftpuser')
read -p "Enter new FTP user [ftpuser]: " FTP_USER
FTP_USER=${FTP_USER:-ftpuser}

# Prompt for new FTP user's password (default is 'ftppassword')
read -p "Enter new FTP user's password [ftppassword]: " FTP_PASSWORD
FTP_PASSWORD=${FTP_PASSWORD:-ftppassword}

# Update package lists
sudo apt-get update

# Install vsftpd
sudo apt-get install -y vsftpd

# Backup the original configuration file
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

# Enable local users to login by uncommenting local_enable=YES
sudo sed -i 's/^#local_enable=YES/local_enable=YES/' /etc/vsftpd.conf

# Allow write operations by uncommenting write_enable=YES
sudo sed -i 's/^#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf

# Restart vsftpd service to apply changes
sudo service vsftpd restart

# Check if /usr/sbin/nologin is in /etc/shells
if ! grep -q "/usr/sbin/nologin" /etc/shells; then
    echo "/usr/sbin/nologin" | sudo tee -a /etc/shells
fi

# Create a new FTP user
sudo useradd -m $FTP_USER -s /usr/sbin/nologin
echo "$FTP_USER:$FTP_PASSWORD" | sudo chpasswd

echo "vsftpd has been configured and a new FTP user ($FTP_USER) has been created."

