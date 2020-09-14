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

echo "========================================================="
echo "    Starting installation of Saraswati."
echo "    SUDO password needed for various installation steps."
echo "========================================================="
sudo DEBIAN_FRONTEND=noninteractive apt update && sudo DEBIAN_FRONTEND=noninteractive apt install snapd wget iptables -y
echo ">>> Installing LXD..."
sudo snap install lxd
# TODO (glost) From which step exactly?
lxd --version > /dev/null 2>&1 || bash -c 'echo ">>> Error during installation of LXD. Aborting, please proceed manually from the \"LXD\" step." ; exit 1'
echo ">>> Initalizing LXD with default values and a ZFS storage pool of 250 GB..."
sudo lxd init --auto --storage-backend zfs --storage-create-loop 250 --storage-pool default
sudo sysctl net.ipv4.ip_forward | grep -q 1
if [[ $? -ne 0 ]] ; then
    sudo bash -c "echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-saraswati.conf"
    #TODO (glost) Does write apply or does it do the same as the above?
    sudo sysctl -w net.ipv4.ip_forward=1
    echo ">>> IPv4 Forwarding was not set!"
fi
echo ">>> Creating VM to host modules..."
sudo lxc profile create saraswati-basic
wget -qO- https://raw.githubusercontent.com/goost/saraswati/develop/saraswati-basic.yml | sudo lxc profile edit saraswati-basic
sudo lxc launch images:ubuntu/focal/cloud saraswati -p default -p saraswati-basic --vm -c security.secureboot=false -c limits.cpu=$(nproc) -c limits.memory=$(expr $(grep -Po "MemTotal:\s+\K[0-9]+" /proc/meminfo) - 2000000)kB
echo ">>> Waiting for the VM to configure itself and start..."
while [[ "$(sudo lxc exec saraswati -- cloud-init status 2>&1)" != "status: done" ]]; do
sleep 10
echo ">>> Configuring..."
done
# TODO (glost) This regexes needs more testing!
# TODO (glost) Static IP for container else this is for naught - isn't  it?
echo ">>> Creating Iptables rules for accessing the VM from the Internet."
saraswati_ip_address=$(sudo lxc info saraswati | grep -Po '[^docker]0:\sinet\s\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
saraswati_host_device=$(ip route get 176.9.93.198 | grep -Po 'dev\s\K[A-Za-z0-9]+(?=\s)')
echo ">>> Got" $saraswati_ip_address " as the IP-Address of the container. If this is wrong, the IPtables rules need to be adjusted!"
echo ">>> Got" $saraswati_host_device " as the primary ethernet device of the host. If this is wrong, the IPtables rules need to be adjusted!"
sudo iptables -t nat -I PREROUTING -i $saraswati_host_device  -p TCP -d $(hostname) --dport 80 -j DNAT --to-destination $saraswati_ip_address:80
sudo iptables -t nat -I PREROUTING -i $saraswati_host_device  -p TCP -d $(hostname) --dport 443 -j DNAT --to-destination $saraswati_ip_address:443
echo ">>> Installing iptables-persistent package, please answer the pop-up with 'Yes' to persist the currently created rules."
echo ">>> If the IP-Address or the ethernet device were wrong, manually adjust the rules and save them (refer to the ReadMe)."
sudo apt install iptables-persistent -y
echo ">>> Creating Auth and modules containers..."
sudo lxc exec saraswati -- su -l ubuntu -c "cd ~/saraswati/authentification ; bash config.sh "
echo ">>> Starting containers..."
sudo lxc exec saraswati -- su -l ubuntu -c "cd ~/saraswati/authentification ; bash startup.sh"