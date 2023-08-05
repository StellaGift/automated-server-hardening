#!/bin/bash

#Function to validate if the input is a valid IP address
validate_ip() {
    local ip_pattern='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
    if [[ $1 =~ $ip_pattern ]]; then
        return 0 # Valid IP address
    else
        return 1 # Invalid IP address
fi
}

#Main script to get IP
echo "Enter IP address of remote server: "
read server_ip

# Validate the entered IP address
if validate_ip "$server_ip"; then
    echo -e "Valid IP address format.\nIP address recieved and saved in a file."   #$server_ip

    #Save the IP address to a file called server_IP.txt
    echo "$server_ip" > server_IP.txt
   
   #Do further processing or actions with the IP address here if needed
else
    echo "Invalid IP address format. Please enter a valid IP address."
    exit 1
fi
