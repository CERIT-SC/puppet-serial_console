class serial_console::bootloader::grub2 (
  $ttys_id,
  $speed,
  $timeout
) {
  augeas { 'grub2_terminal':
    incl    => '/etc/default/grub',
    lens    => 'Shellvars.lns',
    context => '/files/etc/default/grub',
    notify  => Class['serial_console::refresh'],
    changes => [
      "set GRUB_TIMEOUT ${timeout}",
      "set GRUB_TERMINAL '\"console serial\"'",
      "set GRUB_SERIAL_COMMAND '\"serial --unit=${ttys_id} --speed=${speed}\"'",
    ],
  }
}
