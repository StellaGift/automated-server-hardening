# **This is an automated server hardening project.**

## ***Created by: Stella Gift ORIJI.***

It is a bash script, hence uses bash interpreter for execution.
The program performs all action on a remote server, being executed on a local machine. It assumes that you have SSH connection to the target remote server and has permission to execute scripts on it.
It contains ten different files aimed at carrying out different function of server hardening processes.
All the files are then bind together and executed in sequence with a single controller script, thereby making the process fully automated.

**file: git_IP.sh** - This is the part of the program that uses user input to get IP address of the remote server. It sets the parameter of the expected IPv4 address in conformity with the global IP pattern as contained in the IP environment variable, this means that if an IP address value set that exceeds 255 is entered, it throws an error and exits with a status of 1. The entered IP address is written into a file named server_IP.txt automatically and every other succeeding process of the program will read that file to perform their own operations on the remote server without asking for user input of IP address again.

**File: generate_sshkeypair.sh** - This generates SSH key pair on the local machine, saves it in the standard SSH path and copies the public key to the remote server authorized_keys file. If SSH pair already exists, it reports that and exits with a status of 0.

**File: reconcile_keys2.sh** - This reconciles public key authentication between the standard user and the root account on the remote server and also reconciles private key propagation between the standard administrative account and the root account on the local machine. This process ensures that permission issues is handled during interaction across, both local and remote servers. This is suitable for key management.

**File: disable-pw_login.sh** - This step disables password authentication, Pluggable Authentication Module(PAM), ChallengeResponse authentication and enables only SSH key authentication. This ensures that access by authentication is controlled and seemless.

**File: update_upgrade2.sh** - This updates and upgrades remote server based on the linux distribution of remote server. It reads the ditribution and executes appropriate cammand for update and upgrade, based on the identified distribution of the linux. Most known linux distribution update and upgrade command is contained therein, such as Debian/Ubuntu, CentOS/RHEL, Fedora, Arch Linux. It throws an error of unsupported distribution if otherwise. Very scalable and best practice for implementing patches.

**File: cron_add.sh** - This adds the update and upgrade job to the crontab entry, if it does not exist already. It schedules to run at non productive time and day of the week. It is scalable and adjustable based on need.

**File: enable_apparmor.sh** - This enables apparmor on the remote server, sets permission of profiles and processes to enforced. It also sets it to activate automatically on system boot. Apparmor is a Mandatory Access Control security system used by Debian/Ubuntu distribution of linux.

**File: scan-and-close_ports3.sh** - This scans remote server for open/listening ports using nmap. It closes ports not in use and excludes port 22 from ports that could be closed, irrespective of being in use or not, ensuring that SSH access is maintained. It saves the scan result into a file automatically and the port closing commands reads the file for ports that should be closed or not.

**File: setup_openvpn_on_remote.sh** - This installs and sets up openvpn on the remote server as both a client and server. This part of the script program assumes that there is a client.ovpn firewall configuration file and a server.conf file (for configuration as a server) present in the same directory.
I have commented out the configuration as a server part, it should be uncommented if there is intention to configure as a server and not as client, or both.

**File: lock_root_login.sh** - This creates a standard user account, adds the account to the sudoer group with extended privileges. It assigns a password to the standard user from a file called users-password.txt and forces the user to change their password upon first login. It then disables direct root login on the remote server and directs the system to request for user password and not root password when privilege commands are attempted.

**File: automated_server_hardening.sh** - This is the script to be executed for evrything to happen. This is the controller script that controls the process and execution of every process mentioned above, using a case statement.
