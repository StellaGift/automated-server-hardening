#!/bin/bash

#Read the remote server IP address from the file
remote_server_ip=$(cat server_IP.txt)

#Function to modify the SSH server configuration on the remote server
modify_ssh_config_remote() {
    #Set the path to the SSH server configuration file on the remote server
    remote_ssh_config="/etc/ssh/sshd_config"

    #Check if the SSH server configuration file exists on the remote server
    if ! ssh "root@$remote_server_ip" "[ -f $remote_ssh_config ]"; then
        echo "SSH server configuration file not found on the remote server: $remote_ssh_config"
        exit 1
    fi

    #Backup the original configuration file on the remote server
    ssh "root@$remote_server_ip" "cp $remote_ssh_config $remote_ssh_config.bak"

    #Modify the SSH server configuration settings on the remote server
    ssh "root@$remote_server_ip" "sudo sed -i 's/^PasswordAuthentication yes$/PasswordAuthentication no/' $remote_ssh_config"
    ssh "root@$remote_server_ip" "sudo sed -i 's/^PubkeyAuthentication no$/PubkeyAuthentication yes/' $remote_ssh_config"
    ssh "root@$remote_server_ip" "sudo sed -i 's/^ChallengeResponseAuthentication yes$/ChallengeResponseAuthentication no/' $remote_ssh_config"
    ssh "root@$remote_server_ip" "sudo sed -i 's/^UsePAM yes$/UsePAM no/' $remote_ssh_config"
}

#Function to restart the SSH service on the remote server
restart_ssh_service_remote() {
  #Restart the SSH service on the remote server based on the available service management-systemctl or service
    ssh "root@$remote_server_ip" "sudo systemctl restart sshd || sudo service ssh restart || echo 'SSH service restart command not found. Please restart SSH manually.'"
}

#Main process of execution
echo "SSH Key-Only Login Script for Remote Server: $remote_server_ip"

#Modify the SSH server configuration on the remote server
modify_ssh_config_remote

#Restart the SSH service on the remote server
restart_ssh_service_remote

echo "SSH key-only login enabled. Password, PAM and ResponseChallenge login disabled on the remote server."

