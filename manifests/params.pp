class serial_console::params {
  $enable = true
  $enable_kernel = true
  $enable_bootloader = true
  $enable_login = true

  # choose last available port
  if size($::serialports) > 1 {
    $ttys = $::serialports[-1]
  } else {
    $ttys = 'ttyS0'
  }

  $tty = 'tty0'
  $speed = 115200
  $term_type = 'vt100'
  $runlevels = '2345'
  $bootloader_timeout = 5
  $logout_timeout = 0

  case $::operatingsystem {
    'RedHat','CentOS','Scientific','SLC','OracleLinux': {
      case $::operatingsystemmajrelease {
        '5','6': {
          $class_kernel = 'grubby'
          $class_bootloader = 'grub1'
          $class_getty = undef
          $cmd_refresh_init = undef
          $cmd_refresh_bootloader = undef
        }

        '7', '8': {
          $class_kernel = 'grub2'
          $class_bootloader = 'grub2'
          $class_getty = undef
          $cmd_refresh_init = undef
          $cmd_refresh_bootloader = undef
        }

        default: {
          fail("Unsupported OS version: \
${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }

    'Debian','Ubuntu': {
      case $::operatingsystemmajrelease {
        '6','7': {
          $class_kernel = 'grub2'
          $class_bootloader = 'grub2'
          $class_getty = 'inittab'
          $cmd_refresh_init = '/sbin/telinit q'
          $cmd_refresh_bootloader = '/usr/sbin/update-grub'
        }

        '8','9','10','20.04': {
          $class_kernel = 'grub2'
          $class_bootloader = 'grub2'
          $class_getty = undef
          $cmd_refresh_init = undef
          $cmd_refresh_bootloader = '/usr/sbin/update-grub'
        }

        default: {
          fail("Unsupported OS version: \
${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }

    default: {
      fail("Unsupported OS: ${::operatingsystem}")
    }
  }
}
