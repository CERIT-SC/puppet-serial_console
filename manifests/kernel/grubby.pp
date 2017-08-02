class serial_console::kernel::grubby {
  if ! empty($::serial_console::tty) {
    $_kparams = "console=${::serial_console::tty} console=${::serial_console::ttys},${::serial_console::speed}"
  } else {
    $_kparams = "console=${::serial_console::ttys},${::serial_console::speed}"
  }

  Exec {
    path => '/bin:/usr/bin:/sbin:/usr/sbin',
  }

  exec { 'grubby-console-clean':
    command => "grubby --update-kernel DEFAULT --remove-args '${_kparams}'",
    unless  => "grubby --info DEFAULT | egrep '^args=.*${_kparams}'",
  }

  exec { 'grubby-console':
    command => "grubby --update-kernel DEFAULT --args '${_kparams}'",
    unless  => "grubby --info DEFAULT | egrep '^args=.*${_kparams}'",
    require => Exec['grubby-console-clean'],
  }

  exec { 'grubby-rhgb':
    command => 'grubby --update-kernel DEFAULT --remove-args \'rhgb\'',
    onlyif  => 'grubby --info DEFAULT | egrep \'^args=.*rhgb\'',
  }
}
