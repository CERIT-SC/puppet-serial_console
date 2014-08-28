class serial_console (
  $enable                 = $serial_console::params::enable,
  $enable_kernel          = $serial_console::params::enable_kernel,
  $enable_bootloader      = $serial_console::params::enable_bootloader,
  $enable_login           = $serial_console::params::enable_login,
  $device                 = $serial_console::params::device,
  $speed                  = $serial_console::params::speed,
  $kargs_erb              = $serial_console::params::kargs_erb,
  $runlevels              = $serial_console::params::runlevels,
  $bootloader_timeout     = $serial_console::params::bootloader_timeout,
  $logout_timeout         = $serial_console::params::logout_timeout,
  $cmd_refresh_init       = $serial_console::params::cmd_refresh_init,
  $cmd_refresh_bootloader = $serial_console::params::cmd_refresh_bootloader
) inherits serial_console::params {

  validate_bool($enable, $enable_kernel, $enable_bootloader, $enable_login)
  validate_string($device, $kargs_erb, $runlevels)

  unless is_integer($speed) {
    validate_re($speed, '^\d+$')
  }

  unless is_integer($runlevels) {
    validate_re($runlevels, '^\d+$')
  }

  unless is_integer($bootloader_timeout) {
    validate_re($bootloader_timeout, '^\d+$')
  }

  unless is_integer($logout_timeout) {
    validate_re($logout_timeout, '^\d+$')
  }

  if $cmd_refresh_init {
    validate_absolute_path($cmd_refresh_init)
  }

  if $cmd_refresh_bootloader {
    validate_absolute_path($cmd_refresh_bootloader)
  }

  # device without /dev prefix
  $ttys_name=regsubst($device,'^(/dev/)?(ttyS.+)$','\2')

  # serial port number
  $ttys_id=regsubst($ttys_name,'^ttyS(\d+)$','\1')

  if $enable {
    validate_string($ttys_name, $ttys_id)
    unless ($ttys_name in $serial_console::params::ports) {
      fail("Invalid serial port: ${device}")
    }

    # kernel serial console
    if $enable_kernel and $serial_console::params::class_kernel {
      class { "serial_console::kernel::${serial_console::params::class_kernel}":
        ttys_name => $ttys_name,
        speed     => $speed,
        kargs_erb => $kargs_erb,
      }
    }

    # GRUB over serial console
    if $enable_bootloader and $serial_console::params::class_bootloader {
      class { "serial_console::bootloader::${serial_console::params::class_bootloader}":
        ttys_id => $ttys_id,
        speed   => $speed,
        timeout => $bootloader_timeout,
      }
    }

    # "login" over serial console
    if $enable_login and $serial_console::params::class_getty {
      class { "serial_console::getty::${serial_console::params::class_getty}":
        ttys_name => $ttys_name,
        ttys_id   => $ttys_id,
        speed     => $speed,
        runlevels => $runlevels,
      }
    }

    # shell login profile for automatic logout on inactivity
    if is_numeric($logout_timeout) and $logout_timeout>0 {
      $autologout_ensure=file
    } else {
      $autologout_ensure=absent
    }

    file { '/etc/profile.d/ttyS_autologout.sh':
      ensure  => $autologout_ensure,
      content => template('serial_console/ttyS_autologout.sh.erb'),
    }

    class { 'serial_console::refresh':
      cmd_refresh_init       => $cmd_refresh_init,
      cmd_refresh_bootloader => $cmd_refresh_bootloader,
    }
  }
}
