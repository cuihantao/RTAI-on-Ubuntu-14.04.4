# RTAI-on-Ubuntu-14.04.4
Install RTAI on Ubuntu 14.04.4

## Getting started

**It is recommended to run this on a VM**

Download and install [Ubuntu 14.04.4](http://releases.ubuntu.com/14.04/).

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
Processor type and features
    -> Processor family = Select yours
    -> Maximum number of CPUs (NR_CPUS) = Set your number (it's generally "4")
    -> SMT (Hyperthreading) scheduler support = DISABLE IT
Power Management and ACPI options
    CPU idle PM support = DISABLE IT
```

Run as root:
```
sudo ./rtai-on-ubuntu
```

Notes:
 * The build process can take a long time (1 hour?)
 * You will be prompted before building
 * Your machine will reboot to the RTAI kernel after installation
