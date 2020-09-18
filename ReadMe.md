# Project Saraswati

Computer Networks' learning modules. WORK IN PROGRESS - ALPHA STATE

## Table of Contents
- [Project Saraswati](#project-saraswati)
  - [Table of Contents](#table-of-contents)
  - [TL;DR](#tldr)
  - [Installation](#installation)
    - [0. Prerequisites](#0-prerequisites)
    - [1. Setup](#1-setup)
      - [1.1 LXD](#11-lxd)
      - [1.2 Containers](#12-containers)

## TL;DR

Only latest Ubuntu is supported. Make sure your system is capable of virtualization (nested is not tested).
The install scripts assumes a fresh but updated Ubuntu Minimal installation, executed as a non-root user.
There needs to be at least 6 GB of RAM installed.

`bash <(wget -O- https://raw.githubusercontent.com/goost/saraswati/develop/install.sh)`

This will install LXD, create a VM, populate it with needed programs and the available exercise modules.
Ports 80 and 443 will be proxied to the created VM.

The usually risks of running scripts from the Internet apply.

## Installation

### 0. Prerequisites

  - Sysbox (used in the VM) relys on features only available on Ubuntu so far.
  - Although the guest and the host theoretically need not to use the same distro, for simplicity sake a Ubuntu host is assumed.
  - Hence, the latest Ubuntu is recommended and the only distro supported and tested.
  - Change the commands accordingly for other distros.
  - The system needs to be able to run a VM, nested virtualization is untested.
  - The system should be securely configured and up-to-date. A non-root user is assumed.
  - Iptables need to be installed, `sudo apt install iptables`
  - In `/etc/sysctl.conf` IP4 forwarding must be enabled: `net.ipv4.ip_forward = 1`
  - Reload sysctl `sudo sysctl --system` if ipv4 forwarding was not enabled

### 1. Setup

#### 1.1 LXD

  1. Install LXD
     -  LXD is best installing by following the
    [official guide](https://linuxcontainers.org/lxd/getting-started-cli/#installation).
     As of the time of writing, version 4.X is the latest one and the one used.
     - Condensed steps on Ubuntu minimal:
       1. `sudo apt update && sudo apt upgrade && sudo apt install snapd -y`
       2. `sudo snap install lxd`
       3. `sudo lxd init`
          - Choose approbiate settings, default ones if unsure. Keep in mind to allocate enough storage space for the VM to use later.
          - E.gb `sudo lxd init --auto --storage-backend zfs --storage-create-loop 250 --storage-pool default`
  2. Create a new profile `sudo lxc profile create saraswati-basic`
  3. Fill it with the contents of [saraswati-basic.yml](./saraswati-basic.yml) `sudo lxc profile edit saraswati-basic < saraswati-basic.yml`
     - Change the size of the disk if less than 250GB were allocated for the storage pool.
  4. Lauch a vm, set the ressources accordingly. Assuming full CPUs and 2GB less RAM:
     - `sudo lxc launch images:ubuntu/focal/cloud saraswati -p default -p saraswati-basic --vm -c security.secureboot=false -c limits.cpu=$(nproc) -c limits.memory=$(expr $(grep -Po "MemTotal:\s+\K[0-9]+" /proc/meminfo) - 2000000)`
  5. Wait for the VM to launch and configure itself
     - `while [[ "$(sudo lxc exec saraswati -- cloud-init status 2>&1)" != "status: done" ]]; do sleep 10; echo "Configuring..."; done`
  6. Setup iptables rules to redirect http and https traffic from the web to the vm
     1. `saraswati_ip_address=$(sudo lxc info saraswati | grep -Po '[^docker]0:\sinet\s\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')`
        - This regex may fail, what we want is the ipv4 address of the saraswati vm as shown by `sudo lxc info saraswati`
     2. `saraswati_host_device=$(ip route get 176.9.93.198 | grep -Po 'dev\s\K[A-Za-z0-9]+(?=\s)')`
        - This regex may fail, what we want is the primary ethernet device name of the host `ip route get 176.9.93.198` (the used device)
     3. `sudo iptables -t nat -I PREROUTING -i $saraswati_host_device  -p TCP -d $(hostname) --dport 80 -j DNAT --to-destination $saraswati_ip_address:80`
     4. `sudo iptables -t nat -I PREROUTING -i $saraswati_host_device  -p TCP -d $(hostname) --dport 443 -j DNAT --to-destination $saraswati_ip_address:443`
     5. `sudo apt install iptables-persistent -y`, answer yes to have the rules saved automagically.
        - To save them manually, use `sudo bash -c "iptables-save -f /etc/iptables/rules.v4"`

#### 1.2 Containers

  1. Execute the configuration script inside the vm `sudo lxc exec saraswati -- su -l ubuntu -c "cd ~/saraswati ; bash configure.sh "`
  2. Build the base image for the web shell `sudo lxc exec saraswati -- su -l ubuntu -c "cd ~/saraswati/ttyd-base ; docker build -t ttyd-base ."`
  3. Start the containers inside the vm `sudo lxc exec saraswati -- su -l ubuntu -cd "~/saraswati ; bash startup.sh"`