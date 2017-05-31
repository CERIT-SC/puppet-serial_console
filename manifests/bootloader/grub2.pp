class serial_console::bootloader::grub2 {
  $_grub_serial_cmd = "serial --unit=${::serial_console::_ttys_id} --speed=${::serial_console::speed}"

  augeas { 'grub2_terminal':
    incl    => '/etc/default/grub',
    lens    => 'Shellvars.lns',
    context => '/files/etc/default/grub',
    notify  => Class['::serial_console::refresh'],
    changes => [
      "set GRUB_TIMEOUT ${::serial_console::bootloader_timeout}",
      "set GRUB_TERMINAL '\"console serial\"'",
      "set GRUB_SERIAL_COMMAND '\"${_grub_serial_cmd}\"'",
    ],
  }
}
