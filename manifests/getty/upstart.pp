class serial_console::getty::upstart (
  $ttys,
  $ttys_id,
  $speed,
  $term_type,
  $runlevels
) {
  file { "/etc/init/$ttys.conf":
    ensure => file,
    content => template('serial_console/ttyS_agetty.conf.erb'),
  }
  augeas { "securetty_$ttys":
    context => "/files/etc/securetty",
    changes => [ "ins 0 before /files/etc/securetty/1",
                 "set /files/etc/securetty/0 $ttys",],
    onlyif => "match *[.='$ttys'] size == 0",
  }

}
