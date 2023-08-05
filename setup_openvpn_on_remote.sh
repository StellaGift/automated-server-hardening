#!/bin/bash

#Read the remote server's IP address from server_IP.txt
server_ip=$(cat server_IP.txt)

#Function to enable IP forwarding for the server
enable_ip_forwarding() {
    ssh "$server_ip" "echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf"
    ssh "$server_ip" "sudo sysctl -p"
}

#Function to start OpenVPN as a client
start_openvpn_client() {
    ssh "$server_ip" "sudo openvpn /etc/openvpn/client.ovpn &"
}

#Function to start OpenVPN as a server
start_openvpn_server() {
    ssh "$server_ip" "sudo openvpn /etc/openvpn/server.conf &"
}

#Main function
main() {
    #Copy client configuration file
    if [ -f "client.ovpn" ]; then
        scp client.ovpn "$server_ip:/tmp/client.ovpn"
        ssh "$server_ip" "sudo cp /tmp/client.ovpn /etc/openvpn/client.ovpn"
    else
        echo "Error: Client configuration file 'client.ovpn' not found."
        exit 1
    fi

    #Start OpenVPN as a client
    echo "Starting OpenVPN as a client on remote server..."
    start_openvpn_client

    #Enable IP forwarding for server (uncomment the line below if you want to set up a server)
    # enable_ip_forwarding

    # Copy server configuration file (uncomment the lines below if you want to set up a server)
    # if [ -f "server.conf" ]; then
    #     scp server.conf "$server_ip:/tmp/server.conf"
    #     ssh "$server_ip" "sudo cp /tmp/server.conf /etc/openvpn/server.conf"
    # else
    #     echo "Error: Server configuration file 'server.conf' not found."
    #     exit 1
    # fi

    #Start OpenVPN as a server (uncomment the line below if you want to set up a server)
    # echo "Starting OpenVPN as a server on remote server..."
    # start_openvpn_server

    echo "OpenVPN setup completed on remote server."
}

#Run the main function
main

