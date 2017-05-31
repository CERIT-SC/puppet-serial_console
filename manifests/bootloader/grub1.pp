class serial_console::bootloader::grub1 {
  augeas { 'grub1_terminal':
    incl    => $::grub1conf,
    lens    => 'Grub.lns',
    context => "/files${::grub1conf}",
    changes => [
      'rm hiddenmenu',

      'rm serial',
      'ins serial before title[1]',
      "set serial/unit ${::serial_console::_ttys_id}",
      "set serial/speed ${::serial_console::speed}",

      'rm terminal',
      'ins terminal before title[1]',
      "set terminal/timeout ${::serial_console::bootloader_timeout}",
      'ins console after terminal/timeout', # 2.
      'ins serial after terminal/timeout', # 1.
    ],
  }
}
