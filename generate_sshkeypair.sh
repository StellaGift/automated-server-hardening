#!/bin/bash

# Function to check if the SSH key pair already exists
check_ssh_key_exists() {
    if [ -f ~/.ssh/id_rsa ] && [ -f ~/.ssh/id_rsa.pub ]; then
        return 0 # SSH key pair exists
    else
        return 1 # SSH key pair does not exist
    fi
}

# Function to copy the public key to the server
copy_public_key_to_server() {
    server_ip=$(cat server_IP.txt)
    ssh-copy-id -i ~/.ssh/id_rsa.pub "stellagift@$server_ip"
    if [ $? -eq 0 ]; then
        echo "Public key copied successfully to the server."
    else
        echo "Failed to copy the public key to the server."
    fi
}

# Main script starts here
echo "SSH Key Generation and Copy Script"

if check_ssh_key_exists; then
    echo "SSH key pair already exists."
    exit 1
fi

# Specify the full path for the SSH key files
ssh_key_dir="$HOME/.ssh"
private_key_file="$ssh_key_dir/id_rsa"
public_key_file="$ssh_key_dir/id_rsa.pub"

echo "Generating SSH key pair..."
ssh-keygen -t rsa -b 4096 -f "$private_key_file"

echo "SSH key pair generated successfully."

echo "Copying the public key to the server..."
copy_public_key_to_server
