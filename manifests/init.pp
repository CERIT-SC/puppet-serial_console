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
  $class_kernel           = $serial_console::params::class_kernel,
  $class_bootloader       = $serial_console::params::class_bootloader,
  $class_getty            = $serial_console::params::class_getty,
  $cmd_refresh_init       = $serial_console::params::cmd_refresh_init,
  $cmd_refresh_bootloader = $serial_console::params::cmd_refresh_bootloader
) inherits serial_console::params {

  validate_bool($enable, $enable_kernel, $enable_bootloader, $enable_login)
  validate_string($ttys, $runlevels)
  validate_re("${speed}", '^\d+$')
  validate_re("${runlevels}", '^\d+$')
  validate_re("${bootloader_timeout}", '^\d+$')
  validate_re("${logout_timeout}", '^\d+$')

  unless empty($cmd_refresh_init) {
    validate_absolute_path($cmd_refresh_init)
  }

  unless empty($cmd_refresh_bootloader) {
    validate_absolute_path($cmd_refresh_bootloader)
  }

  # validate ttys and extract id
  validate_re($ttys, '^ttyS(\d+)$')
  $_ttys_id = regsubst($ttys,'^ttyS(\d+)$','\1')
  validate_re($_ttys_id, '^\d+$')

  if ! ($ttys in $::serialports) {
    err("Invalid serial port '${ttys}'")

  } elsif $enable {
    # kernel serial console
    if $enable_kernel and ! empty($class_kernel) {
      contain "::serial_console::kernel::${class_kernel}"
    }

    # GRUB over serial console
    if $enable_bootloader and ! empty($class_bootloader) {
      contain "::serial_console::bootloader::${class_bootloader}"
    }

    # "login" over serial console
    if $enable_login and ! empty($class_getty) {
      contain "::serial_console::getty::${class_getty}"
    }

    # shell login profile for automatic logout on inactivity
    contain ::serial_console::autologout
  }

  contain ::serial_console::refresh
}
