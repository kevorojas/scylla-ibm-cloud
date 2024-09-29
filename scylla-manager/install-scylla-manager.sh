#!/bin/bash

#################################################################
# Script to install ScyllaDB on a remote Debian-based system
#################################################################

# Variables
REMOTE_USER="your_username"
REMOTE_HOST="your_remote_host"
REMOTE_SCRIPT="/tmp/install-scylla-manager-remote.sh"

# Create a script to run on the remote server
cat << 'EOF' > $REMOTE_SCRIPT
#!/bin/bash

# Update package list and install curl
apt update && apt install curl -y

# Install ScyllaDB
curl -sSf get.scylladb.com/server | sudo bash

# Run ScyllaDB configuration
scylla_setup --no-raid-setup --online-discard 1 --nic eth0 \
             --io-setup 1 --no-fstrim-setup --no-rsyslog-setup

# Start ScyllaDB
systemctl start scylla-server

# Enable ScyllaDB to start on boot
systemctl enable scylla-server

# Install Scylla Manager
sudo apt-get install apt-transport-https dirmngr -y

mkdir -p /etc/apt/keyrings
gpg --homedir /tmp --no-default-keyring --keyring /etc/apt/keyrings/scylladb.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys A43E06657BAC99E3

wget -O /etc/apt/sources.list.d/scylla-manager.list https://downloads.scylladb.com/deb/debian/scylladb-manager-3.3.list

apt-get update -y

apt-get install scylla-manager-server scylla-manager-client -y

scyllamgr_setup -y

systemctl start scylla-manager

EOF

# Copy the script to the remote server
scp $REMOTE_SCRIPT $REMOTE_USER@$REMOTE_HOST:$REMOTE_SCRIPT

# Execute the script on the remote server
ssh $REMOTE_USER@$REMOTE_HOST "bash $REMOTE_SCRIPT"

# Clean up the remote script
ssh $REMOTE_USER@$REMOTE_HOST "rm $REMOTE_SCRIPT"

# Clean up the local script
rm $REMOTE_SCRIPT
