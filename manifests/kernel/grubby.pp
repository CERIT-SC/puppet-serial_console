class serial_console::kernel::grubby (
  $ttys_name,
  $speed,
  $kargs_erb
) {
  $kargs = inline_template($kargs_erb)

  exec { 'grubby-console-clean':
    command => "grubby --update-kernel DEFAULT --remove-args '${kargs}'",
    unless  => "grubby --info DEFAULT | egrep '^args=.*${kargs}'",
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  }

  exec { 'grubby-console':
    command => "grubby --update-kernel DEFAULT --args '${kargs}'",
    unless  => "grubby --info DEFAULT | egrep '^args=.*${kargs}'",
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    require => Exec['grubby-console-clean'],
  }

  exec { 'grubby-rhgb':
    command => 'grubby --update-kernel DEFAULT --remove-args \'rhgb\'',
    onlyif  => 'grubby --info DEFAULT | egrep \'^args=.*rhgb\'',
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  }
}
