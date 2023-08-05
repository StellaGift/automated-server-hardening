#!/bin/bash

#Check if the script is executed with root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run with root privileges. Please use sudo or run as root."
  exit 1
fi

#Check if a username argument is provided
if [ -z "$1" ]; then
  read -p "Please enter the desired username: " username
  if [ -z "$username" ]; then
    echo "Username not provided. Exiting."
    exit 1
  fi
else
  username="$1"
fi

#Read the server IP address from the file
server_ip=$(cat server_IP.txt)

#Check if the IP address is valid (optional - you can skip this check if needed)
#if ! [[ $server_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  #echo "Invalid server IP address in server_IP.txt file."
  #exit 1
#fi

#Read the password from the file users-password.txt
password=$(cat users-password.txt)

#Create the user with a home directory on the remote server and set the password
ssh "root@$server_ip" "useradd -m $username && echo -e '$password\n$password' | passwd $username"

#Add the user to the sudo group on the remote server
ssh "root@$server_ip" "usermod -aG sudo $username"

#Set the password expiration to force change on first login
ssh "root@$server_ip" "chage -d 0 $username"

#Disable direct root login on the remote server by locking the root account
ssh "root@$server_ip" "passwd -l root"

#Configure sudo to require user's password, not root's password on the remote server
ssh "root@$server_ip" "sed -i 's/^Defaults\s+targetpw/# Defaults targetpw/' /etc/sudoers"

echo "User '$username' has been created with the provided password from users-password.txt. The user will be forced to change their password on the first login. Root login has been disabled."

