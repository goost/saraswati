#!/bin/bash

set -e
# This script assumes:
# - Ubuntu minimal focal
# - Fresh install, but up-to-date
# - Running as non-root-user
# - At least 250 GB of space for the storage pool.
# Afterwards:
# - LXD will be installed, a VM will be running
# - Docker will be installed in configured inside the VM, along with Sysbox.
# - All the modules available in the repo will be up-and-running
# - Ports 80 and 443 on the host will be proxied to the VM

echo "Enter an eMail address for Let's Encrypt certificate generation."
echo "(Only a minimal validity check is performed.)"
read email_address

quick_email_regex="(.+)@(.+)\.(.+)"
if [[ $email_address =~ $quick_email_regex ]] ; then
    echo "Using email:" $email_address
else
    echo "The address should at least have an '@' and a domain at the end!\nPlease restart the installation." >$2
    exit 1
fi

sudo apt udpdate && sudo apt install snapd wget -y
sudo snap install lxd
lxd --version 2> /dev/null || bash -c 'echo "Error during installation of LXD. Aborting, please proceed manually from the \"LXD\" step." >&2 ; exit 1'
echo "Initalizing LXD with default values and a ZFS storage pool of  (https://linuxcontainers.org/lxd/getting-started-cli/#initial-configuration)"
sudo lxd init --auto --storage-backend zfs --storage-create-loop 250 --storage-pool default
sudo lxc profile create saraswati-vm
wget -qO- https://raw.githubusercontent.com/goost/saraswati/develop/install.sh | sudo lxc profile edit saraswati-vm
sudo lxc launch images:ubuntu/focal/cloud saraswati -p default -p saraswati-vm --vm -c security.secureboot=false
echo "Waiting for the VM to configure itself and start..."
while [ "$(sudo lxc exec saraswati -- cloud-init status 2>&1)" != "status: done"  ]; do
sleep 10
echo "Configuring..."
done
sudo lxc exec saraswati -- su --login ubuntu