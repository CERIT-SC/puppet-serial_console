class serial_console::autologout {
  if $::serial_console::logout_timeout > 0 {
    $_ensure=file
  } else {
    $_ensure=absent
  }

  file { '/etc/profile.d/ttyS_autologout.sh':
    ensure  => $_ensure,
    content => template('serial_console/ttyS_autologout.sh.erb'),
  }
}
