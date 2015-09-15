class serial_console::autologout (
  $logout_timeout
) {
  if is_numeric($logout_timeout) and $logout_timeout>0 {
    $ensure=file
  } else {
    $ensure=absent
  }

  file { '/etc/profile.d/ttyS_autologout.sh':
    ensure  => $ensure,
    content => template('serial_console/ttyS_autologout.sh.erb'),
  }
}
