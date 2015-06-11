class serial_console (
  $enable                 = $serial_console::params::enable,
  $enable_kernel          = $serial_console::params::enable_kernel,
  $enable_bootloader      = $serial_console::params::enable_bootloader,
  $enable_login           = $serial_console::params::enable_login,
  $tty                    = $serial_console::params::tty,
  $ttys                   = $serial_console::params::ttys,
  $speed                  = $serial_console::params::speed,
  $term_type              = $serial_console::params::term_type,
  $runlevels              = $serial_console::params::runlevels,
  $bootloader_timeout     = $serial_console::params::bootloader_timeout,
  $logout_timeout         = $serial_console::params::logout_timeout,
  $cmd_refresh_init       = $serial_console::params::cmd_refresh_init,
  $cmd_refresh_bootloader = $serial_console::params::cmd_refresh_bootloader
) inherits serial_console::params {

  validate_bool($enable, $enable_kernel, $enable_bootloader, $enable_login)
  validate_string($ttys, $runlevels)
  validate_re($speed, '^\d+$')
  validate_re($runlevels, '^\d+$')
  validate_re($bootloader_timeout, '^\d+$')
  validate_re($logout_timeout, '^\d+$')

  if $cmd_refresh_init {
    validate_absolute_path($cmd_refresh_init)
  }

  if $cmd_refresh_bootloader {
    validate_absolute_path($cmd_refresh_bootloader)
  }

  # validate ttys and extract id
  validate_re($ttys, '^ttyS(\d+)$')
  $ttys_id = regsubst($ttys,'^ttyS(\d+)$','\1')
  validate_re($ttys_id, '^\d+$')

  if ! ($ttys in $serial_console::params::l_serialports) {
    err("Invalid serial port '${ttys}'")

  } elsif $enable {
    # kernel serial console
    $class_kernel = $serial_console::params::class_kernel
    if $enable_kernel and $class_kernel {
      class { "serial_console::kernel::${class_kernel}":
        tty       => $tty,
        ttys      => $ttys,
        speed     => $speed,
      }
    }

    # GRUB over serial console
    $class_bootloader = $serial_console::params::class_bootloader
    if $enable_bootloader and $class_bootloader {
      class { "serial_console::bootloader::${class_bootloader}":
        ttys_id => $ttys_id,
        speed   => $speed,
        timeout => $bootloader_timeout,
      }
    }

    # "login" over serial console
    $class_getty = $serial_console::params::class_getty
    if $enable_login and $class_getty {
      class { "serial_console::getty::${class_getty}":
        ttys      => $ttys,
        ttys_id   => $ttys_id,
        speed     => $speed,
        runlevels => $runlevels,
        term_type => $term_type,
      }
    }

    # shell login profile for automatic logout on inactivity
    class { 'serial_console::autologout':
      logout_timeout => $logout_timeout,
    }
  }

  class { 'serial_console::refresh':
    cmd_refresh_init       => $cmd_refresh_init,
    cmd_refresh_bootloader => $cmd_refresh_bootloader,
  }
}
