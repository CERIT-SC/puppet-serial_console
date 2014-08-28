class serial_console::params {
  $enable = true
  $enable_kernel = true
  $enable_bootloader = true
  $enable_login = true

  # by default setup console on last available serial port
  $ports = reverse(split($::serialports,','))

  if $ports[0] {
    $device = $ports[0]
  } else {
    $device = 'ttyS0'
  }

  $speed = 115200
  $runlevels = '2345'
  $bootloader_timeout = 5
  $logout_timeout = 0
  $kargs_erb = 'console=tty0 console=<%= @ttys_name %>,<%= @speed %>'

  case $::operatingsystem {
    redhat,centos,scientific,oraclelinux: {
      case $::operatingsystemmajrelease {
        5,6: {
          $class_kernel = 'grubby'
          $class_bootloader = 'grub1'
          $class_getty = undef
          $cmd_refresh_init = undef
          $cmd_refresh_bootloader = undef
        }

        7: {
          $class_kernel = 'grub2'
          $class_bootloader = 'grub2'
          $class_getty = undef
          $cmd_refresh_init = undef
          $cmd_refresh_bootloader = '/usr/sbin/grub2-mkconfig -o /boot/grub2/grub.cfg'
        }

        default: {
          fail("Unsupported OS version: \
${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }

    debian: {
      case $::operatingsystemmajrelease {
        6,7: {
          $class_kernel = 'grub2'
          $class_bootloader = 'grub2'
          $class_getty = 'inittab'
          $cmd_refresh_init = '/sbin/telinit q'
          $cmd_refresh_bootloader = '/usr/sbin/update-grub'
        }

        default: {
          fail("Unsupported OS version: \
${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
  }

  unless $class_kernel or $class_bootloader or $class_getty {
    fail("Unsupported OS: ${::operatingsystem}")
  }
}
