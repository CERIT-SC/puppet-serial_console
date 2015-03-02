class serial_console::kernel::grubby (
  $tty,
  $ttys,
  $speed
) {
  if $tty {
    $kparams = "console=${tty} console=${ttys},${speed}"
  } else {
    $kparams = "console=${ttys},${speed}"
  }

  exec { 'grubby-console-clean':
    command => "grubby --update-kernel DEFAULT --remove-args '${kparams}'",
    unless  => "grubby --info DEFAULT | egrep '^args=.*${kparams}'",
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  }

  exec { 'grubby-console':
    command => "grubby --update-kernel DEFAULT --args '${kparams}'",
    unless  => "grubby --info DEFAULT | egrep '^args=.*${kparams}'",
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    require => Exec['grubby-console-clean'],
  }

  exec { 'grubby-rhgb':
    command => 'grubby --update-kernel DEFAULT --remove-args \'rhgb\'',
    onlyif  => 'grubby --info DEFAULT | egrep \'^args=.*rhgb\'',
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  }
}
