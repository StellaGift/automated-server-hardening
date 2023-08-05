#!/bin/bash

#Read the remote server credentials and read private key for authentication
REMOTE_USER="stellagift"
REMOTE_SSH_KEY="~/.ssh/id_rsa"

#Read the remote server's IP address from server_IP.txt
REMOTE_SERVER=$(cat server_IP.txt)

#Enable AppArmor on the remote server
ssh -i "$REMOTE_SSH_KEY" "$REMOTE_USER@$REMOTE_SERVER" "sudo systemctl start apparmor && sudo systemctl enable apparmor"

#Display the status on the remote server to verify that AppArmor is running and enabled
ssh -i "$REMOTE_SSH_KEY" "$REMOTE_USER@$REMOTE_SERVER" "sudo apparmor_status"

echo "Mandatory Access Control enforced successfully. Critical processes confined with profile."

