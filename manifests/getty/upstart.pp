class serial_console::getty::upstart (
  $ttys,
  $ttys_id,
  $speed,
  $term_type,
  $runlevels
) 
{
  file { "/etc/init/${ttys}.conf":
    ensure  => present,
    content => template('serial_console/upstart-ttyS.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => service[$ttys],
  }
  service { $ttys:
    ensure      => 'running',
    provider    => 'upstart',
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
  }
}
