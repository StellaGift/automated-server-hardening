#!/bin/bash

#Function to be called on script termination
function on_termination {
  echo "Scan completed.Temporary closure of unused ports completed successfully."
}

#Register the on_termination function to be called when receiving termination signals
trap on_termination INT TERM

echo "Starting port scan and management, pls wait..."

#Read the remote server IP address from the file
server_ip=$(cat server_IP.txt | tr -d '[:space:]')

#Run nmap on the remote server to scan for open ports and save the result to a file
nmap_output=$(ssh root@$server_ip "nmap -T4 -p 1-1024 localhost" 2>&1)
if [ $? -ne 0 ]; then
  echo "Error: Failed to run nmap on the remote server."
  exit 1
fi

echo "$nmap_output" >> nmap_results.txt

#Extract the list of open ports from the nmap_results.txt file
open_ports=$(grep -oP '\d+/open' nmap_results.txt | cut -d '/' -f 1)

#Close all ports that are not in use temporarily for 2 days on the remote server
top_10_ports="22 80 443 53 21 25 110 143 587 993"  #List can be adjusted as required

for port in $top_10_ports; do
  if [ "$port" -ne 22 ] && ! echo "$open_ports" | grep -qw "$port"; then
    ssh root@$server_ip "sudo iptables -A INPUT -p tcp --dport $port -j DROP"
    #Use the line below if you want to block UDP ports as well
    #ssh root@$server_ip "sudo iptables -A INPUT -p udp --dport $port -j DROP"
  fi
done

#Save the iptables rules with a timeout of 2 days on the remote server
ssh root@$server_ip "sudo iptables-save > /usr/share/iptables/rules.v4"  #For IPv4
ssh root@$server_ip "sudo ip6tables-save > /usr/share/iptables/rules.v6"  #For IPv6

#Sleep for 2 days (172800 seconds) before removing the temporary rules
sleep 172800

#Remove the temporary iptables rules on the remote server
for port in $top_10_ports; do
  if [ "$port" -ne 22 ] && ! echo "$open_ports" | grep -qw "$port"; then
    ssh root@$server_ip "sudo iptables -D INPUT -p tcp --dport $port -j DROP"
    #Use the line below if you want to unblock UDP ports as well
    #ssh root@$server_ip "sudo iptables -D INPUT -p udp --dport $port -j DROP"
  fi
done

#Save the iptables rules after removing the temporary rules on the remote server
ssh root@$server_ip "sudo iptables-save > /usr/share/iptables/rules.v4"  #For IPv4
ssh root@$server_ip "sudo ip6tables-save > /usr/share/iptables/rules.v6"  #For IPv6

# The script reaches this point if it completed successfully
echo "Success: Temporary closure of unused ports completed, and ports will be reopened as specified."

