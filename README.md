# Puppet module for system serial console setup

This module configures system for serial console
access (boot loader, kernel and login)

### Requirements

Module has been tested on:

* Puppet 3.6
* OS:
 * Debian 6,7
 * RHEL/CentOS 6,7

Required modules:

* stdlib (https://github.com/puppetlabs/puppetlabs-stdlib)

# Quick Start

Setup

```puppet
include serial_console
```

Full configuration options:

```puppet
class { 'serial_console':
  enable                 => false|true,  # enable configuration
  enable_kernel          => false|true,  # enable kernel config.
  enable_bootloader      => false|true,  # enable bootloader config.
  enable_login           => flase|true,  # enable login over serial config.
  device                 => '...',       # serial device name, e.g. /dev/ttyS0
  speed                  => ...,         # serial port speed, e.g. 115200
  kargs_erb              => '...',       # kernel console args. template
  runlevels              => '...',       # run levels for login over serial
  bootloader_timeout     => '...'        # bootloader timeout
  logout_timeout         => '...',       # interactive session timeout
  cmd_refresh_init       => '...',       # command to refresh init
  cmd_refresh_bootloader => '...',       # command to refresh bootloader
}
```

# Facts

### serialports, usbserialports

Returns comma separated list of available (USB) serial port
device names (without /dev prefix). E.g.: "ttyS0,ttyS1"

### grub1conf

Returns absolute path to GRUB 1 configuration file.

***

CERIT Scientific Cloud, <support@cerit-sc.cz>
