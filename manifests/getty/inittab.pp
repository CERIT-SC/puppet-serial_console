class serial_console::getty::inittab (
  $ttys_name,
  $ttys_id,
  $speed,
  $runlevels
) {
  augeas { "inittab-agetty-${ttys_name}":
    incl    => '/etc/inittab',
    lens    => 'Inittab.lns',
    context => "/files/etc/inittab/T${ttys_id}",
    notify  => Class['serial_console::refresh'],
    changes => [
      'set runlevels 2345',
      'set action respawn',
      "set process '/sbin/getty -8L ${speed} ${ttys_name} vt100'"
    ]
  }
}
