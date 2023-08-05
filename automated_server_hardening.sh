#!/bin/bash

echo -e "Welcome to Automated Service Hardening Process. Remember, you're in control of the execution process...\n"
echo  "1. Enter remote server IP address (invalid format not allowed)."
echo  "2. Generate SSH key pairs and copy public key to remote server."
echo  "3. Reconcile keys."
echo  "4. Disable password, PAM and ResponseChallenge, allow only SSH Authentication."
echo  "5. Update and Upgrade remote system."
echo  "6. Add update and upgrade script to crontab, skip if entry exist."
echo  "7. Activate apparmor to start at system boot and enforce profile policies."
echo  "8. Scan for open/listening ports and close not-in-use ones temporarily."
echo  "9. Activate openVPN and set firewall rules on critical ports."
echo  "10. Lock direct root login, create a standard user account and add to the sudoer group."
echo "11. Finish and exit"

while true; do
    read choice

    case $choice in
        1)
            #Call script for option 1
            ./get_ip.sh
            ;;
        2)
            #Call script for Option 2
            ./generate_sshkeypair.sh
            ;;
        3)
            #Call script for Option 3
            ./reconcile_keys2.sh
            ;;
        4)
            #Call script for option 4
            sudo ./disable-pw_login.sh
            ;;

        5)  #Call script for option 5
            sudo ./update_upgrade2.sh
            ;;

        6)  #Call script for option 6
            ./cron_add.sh
            ;;

        7)  #Call script for option 7
            ./enable_apparmor.sh
            ;;

        8)  #Call script for option 8
            sudo ./scan-and-close_ports3.sh
            ;;

        9)  #Call script for option 9
           sudo ./setup_openvpn_on_remote.sh
            ;;

        10) #Call script for option 10
            sudo ./lock_root_login.sh Technerd
            ;;

        11) #Finish process
            echo "Congratulation! server hardening program completed successfully."
            break
            ;;
        *)
            echo "Invalid choice. Please select again."
            ;;
    esac
done

