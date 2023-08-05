#!/bin/bash

#Function to copy SSH keys from standard user to root on local machine
function copy_ssh_keys_local() {
    sudo cp /home/stella/.ssh/id_rsa /root/.ssh/
    sudo cp /home/stella/.ssh/id_rsa.pub /root/.ssh/
    sudo chown root:root /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
    sudo chmod 600 /root/.ssh/id_rsa
    sudo chmod 644 /root/.ssh/id_rsa.pub
    echo "SSH keys propagated between standard user and root on the local machine."
}

#Function to copy authorized_keys from standard user to root on remote server
function copy_authorized_keys_remote() {
    #Remote server details
    remote_user="stellagift"
    remote_server=$(cat server_IP.txt)

    #Copy authorized_keys from standard user to root user on the remote server
    ssh "$remote_user"@"$remote_server" 'sudo cp ~/.ssh/authorized_keys /root/.ssh/'
    echo "authorized_keys propagated between standard user and root on the remote server."
}

#Call the local function to copy SSH keys from standard user to root on local machine
copy_ssh_keys_local

#Call the remote function to copy authorized_keys from standard user to root on the remote server
copy_authorized_keys_remote

echo "SSH key propagation process completed successfully."

