class serial_console::getty::inittab {
  augeas { "inittab-agetty-${::serial_console::ttys}":
    incl    => '/etc/inittab',
    lens    => 'Inittab.lns',
    context => "/files/etc/inittab/T${::serial_console::_ttys_id}",
    notify  => Class['serial_console::refresh'],
    changes => [
      "set runlevels ${::serial_console::runlevels}",
      'set action respawn',
      "set process '/sbin/getty -8L ${::serial_console::speed} ${::serial_console::ttys} ${::serial_console::term_type}'"
    ]
  }
}
