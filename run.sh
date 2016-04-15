#!/bin/bash

# Author:   Tristan van Vaalen
# Date:     April 2016
# Comments: This is based on instructions found on:
#           Instructions taken from: https://gist.github.com/gaoyifan/c881aa36cd02fb5c1c20
#           !! Make sure you have at least 10GB free space in your root partition !!
#           It is recommended to execute this on a VM! Use at your own risk.

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# We are installing this next to the other kernel sources
cd /usr/src

# Download and unpack RTAI 4.1 and kernel v3.10.32
curl -L https://www.rtai.org/userfiles/downloads/RTAI/rtai-4.1.tar.bz2 | tar xj
curl -L https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.32.tar.xz | tar xJ
curl -L http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.10.32-saucy/linux-image-3.10.32-031032-generic_3.10.32-031032.201402221635_amd64.deb -o linux-image-3.10.32-generic-amd64.deb

# Unpack the archive
dpkg-deb -x linux-image-3.10.32-generic-amd64.deb linux-image-3.10.32-generic-amd64

# Create symlinks to the files for ease of use (optional?)
ln -s linux-3.10.32 linux
ln -s rtai-4.1 rtai

# Make sure we have all the packages
apt-get update
apt-get install --yes cvs subversion build-essential git-core g++-multilib gcc-multilib
apt-get install --yes libtool automake libncurses5-dev kernel-package

# Copy the standard config
cp /usr/src/linux-image-3.10.32-generic-amd64/boot/config-3.10.32-031032-generic /usr/src/linux/.config

# Move in the kernel source dir
cd /usr/src/linux

# Apply the RTAI kernel patch
patch -p1 < /usr/src/rtai/base/arch/x86/patches/hal-linux-3.10.32-x86-5.patch

# Create the config file:
echo "===============MENUCONFIG==============="
echo "----> Your input is needed! <----"
echo "Write these instruction down somehwere!
echo ""
echo "Please configure the following settings:
echo ""
echo "Processor type and features"
echo "    -> Processor family = Select yours"
echo "    -> Maximum number of CPUs (NR_CPUS) = Set your number (it's generally "4")"
echo "    -> SMT (Hyperthreading) scheduler support = DISABLE IT"
echo "Power Management and ACPI options"
echo "    CPU idle PM support = DISABLE IT"
echo "========================================"
read -rsp $'Press any key to start menuconfig...\n' -n 1 key
make menuconfig

# Buidling kernel
make -j `getconf _NPROCESSORS_ONLN` deb-pkg LOCALVERSION=-rtai

# Installing kernel
dpkg -i linux-image-3.10.32-rtai_3.10.32-rtai-1_amd64.deb
dpkg -i linux-headers-3.10.32-rtai_3.10.32-rtai-1_amd64.deb

# Patch grub to start our kernel next time
GRUB_DEFAULT="saved"
GRUB_TIMEOUT="2"
GRUB_HIDDEN_TIMEOUT="10" # make sure grub menu shows
GRUB_HIDDEN_TIMEOUT_QUIET="false"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash lapic=notscdeadline panic=5"
grub-set-default "Ubuntu, with Linux 4.2.0-27-generic"
grub-reboot "Ubuntu, with Linux 3.10.32-rtai"
update-grub

echo "=========Installation complete!========="
echo "The system will reboot to the RTAI kernel now!"
echo "========================================"

echo -n "Rebooting in "
for i in {30..1}; do echo -n "$i " && sleep 1; done

reboot
