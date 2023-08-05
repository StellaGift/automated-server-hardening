#!/bin/bash

#Check if the script is executed with root privileges(must).
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Please use sudo or run as root."
   exit 1
fi

#Update and upgrade the system based on the Linux distribution. Parameter of distro options set for good measures.
function update_upgrade {
   local ip="$1"

   #Use SSH to connect to the remote server and execute update/upgrade commands
   if ssh "root@$ip" "[ -x '/usr/bin/apt' ]"; then
      echo "Updating and upgrading Ubuntu/Debian on $ip..."
      ssh "root@$ip" "apt update && apt upgrade -y"
   elif ssh "root@$ip" "[ -x '/usr/bin/yum' ]"; then
      echo "Updating and upgrading CentOS/RHEL on $ip..."
      ssh "root@$ip" "yum update -y"
   elif ssh "root@$ip" "[ -x '/usr/bin/dnf' ]"; then
      echo "Updating and upgrading Fedora on $ip..."
      ssh "root@$ip" "dnf update -y"
   elif ssh "root@$ip" "[ -x '/usr/bin/pacman' ]"; then
      echo "Updating and upgrading Arch Linux on $ip..."
      ssh "root@$ip" "pacman -Syu --noconfirm"
   else
      echo "Unsupported Linux distribution on $ip. Skipping..."
   fi
}

#Check if 'server_IP.txt' file exists
if [ ! -f "server_IP.txt" ]; then
   echo "File 'server_IP.txt' not found. Please create the file and add IP addresses of remote servers."
   exit 1
fi

#Read IP address from the specified file and execute update_upgrade function
while read -r ip_address; do
   update_upgrade "$ip_address"
done < "server_IP.txt"

echo "Update and upgrade completed successfully!"

