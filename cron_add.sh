#!/bin/bash

#Path to the update and upgrade script
SCRIPT_PATH=~/scripting/script-bashing/server_hardening/server-hardening_ladder/update_upgrade.sh

#Crontab entry for running the script at 8 PM every day
CRON_ENTRY="0 20 * * 5 $SCRIPT_PATH"

#Check if the update and upgrade script exists in the specified path
if [ ! -f "$SCRIPT_PATH" ]; then
   echo "Error: The update and upgrade script was not found in the specified path: $SCRIPT_PATH"
   exit 1
fi

#Check if the crontab entry already exists
if crontab -l | grep -Fq "$SCRIPT_PATH"; then
   echo "Crontab entry for the update and upgrade script already exists. Skipping crontab addition..."
   sleep 3
else
   #Add the crontab entry
   (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
   echo "Crontab entry for the update and upgrade script added successfully."
fi

#Ensure the script is executable
chmod +x "$SCRIPT_PATH"

