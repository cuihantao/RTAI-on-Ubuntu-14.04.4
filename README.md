# RTAI-on-Ubuntu-14.04.4
Install RTAI on Ubuntu 14.04.4

This has been tested on a clean Ubuntu 14.04.4 image on VMware Workstation 12.0.

## About
This downloads, patches, configures, builds and installs RTAI for Ubuntu 14.04.4.
The process takes a while to do manualy and can be quite tricky for some, so this scripts should make your life easier.

#### Explain me the magic!
On first run:
 * The script downloads kernel 3.10.32 and RTAI 4.1. Why these versions? Simple, they are the versions used in my reference instruction.
 * All required packages are installed silently
 * After a small configuration step, the kernel is built with the RTAI patch
 * The kernel is installed
 * Grub config files are changed to launch the RTAI kernel automatically once
 * The system is rebooted into the new kernel

On second run:
 * RTAI is configured
 * RTAI is built
 * RTAI is installed
 * Some config and path patchwork is applied

... aaaand you're done. This process takes about 1 to 2 hours. Just fire it up and go drink your coffee!

## Getting started

**It is recommended to run this on a VM**

Download and install [Ubuntu 14.04.4](http://releases.ubuntu.com/14.04/) **64-bit!**.

Download this script:
```
curl -O https://raw.githubusercontent.com/Scoudem/RTAI-on-Ubuntu-14.04.4/master/rtai-on-ubuntu
```

Set executable:
```
chmod +x rtai-on-ubuntu
```

**While running, you will be prompted to configure the kernel. Please configure as follows:**
```
Enable loadable module support
    -> Module signature verification = no
Processor type and features
    -> Processor family: select your architecture (probably default x86)
    -> Maximum number of CPUs (NR_CPUS): enter your cores (it's generally "4")
    -> SMT (Hyperthreading) scheduler support = no
Power Management and ACPI options
    CPU idle PM support = no (if possible)
```

If you can't disable CPU idle PM support, configure the following:
```
Power Management and ACPI options
    -> Cpu idle Driver for Intel Processors = no
    -> ACPI (Advanced Configuration and Power Interface) Support -> PROCESSOR = no
    -> APM (Advanced Power Management) BIOS support = no
    -> CPU Frequency scaling -> CPU Frequency scaling = no (optional?)
```

Run as root:
```
sudo ./rtai-on-ubuntu
```

Notes:
 * The build process can take a long time (1 hour?)
 * You will be prompted to configure **before** building
 * You don't have to interact while building, so make yourself some coffee
 * Your machine will reboot to the RTAI kernel after installation

After reboot run the script again:
```
sudo ./rtai-on-ubuntu
```

You will be prompted to configure RTAI. **Make sure you set your NUM_CPUS to the correct amount!**. RTAI should be configured properly now. You can do a test run by executing the following:
```
cd /usr/realtime/testsuite/kern/latency/; sudo ./run
```

## Troubleshoot
If you get any error like:
```
insmod: ERROR {somemodule.ko} Operation not permitted
```
check your logs by using:
```
dmesg
```

This error is probably caused by `RTAI CONFIGURED WITH LESS THAN NUM ONLINE CPUS` (ignore all missing symbol errors, since your modules won't load, no symbols can be found). Please run the install script again and configure the right amount of CPUs. If not: you should probably configure something else.

## Quick start:
```
curl -O https://raw.githubusercontent.com/Scoudem/RTAI-on-Ubuntu-14.04.4/master/rtai-on-ubuntu; chmod +x rtai-on-ubuntu; sudo ./rtai-on-ubuntu
```

## Improvements
There is probably a better, more universal way to achieve the same result, but this does something, and thats good too right?
