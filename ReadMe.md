# Project Saraswati

Computer Networks' learning modules. WORK IN PROGRESS - ALPHA STATE

## Table of Contents
- [Project Saraswati](#project-saraswati)
  - [Table of Contents](#table-of-contents)
  - [TL;DR](#tldr)
  - [Installation](#installation)
    - [0. Prerequisites](#0-prerequisites)
    - [1. Initial setup](#1-initial-setup)
      - [1.1 LXD](#11-lxd)

## TL;DR

Only latest Ubuntu is supported. Make sure your system is capable of virtualization (nested is not tested).
The install scripts assumes a fresh but updated Ubuntu Minimal installation, executed as a non-root user.
There need to be at least 250 GB available for the creation of the default storage pool.

`wget -O- https://raw.githubusercontent.com/goost/saraswati/develop/install.sh | bash`

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

### 1. Initial setup
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
          - Script uses `sudo lxd init --auto --storage-backend zfs --storage-create-loop 250 --storage-pool default`
  2. Create a new profile `sudo lxc profile create saraswati-vm`
  3. Fill it with the contents of [saraswati-vm.yml](./saraswati-vm.yml) `sudo lxc profile edit saraswati-vm < saraswati-vm.yml`
  4. Lauch a vm `sudo lxc launch images:ubuntu/focal/cloud saraswati -p default -p saraswati-vm --vm -c security.secureboot=false`
  5. Wait for the VM to launch and configure itself
    - `while [ "$(sudo lxc exec saraswati -- cloud-init status 2>&1)" != "status: done"  ]; do sleep 10; echo "Configuring..."; done`
  6. asd
  7.