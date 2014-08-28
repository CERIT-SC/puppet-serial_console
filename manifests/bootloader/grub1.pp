class serial_console::bootloader::grub1 (
  $ttys_id,
  $speed,
  $timeout
) {
  augeas { 'grub1_terminal':
    incl    => $::grub1conf,
    lens    => 'Grub.lns',
    context => "/files${::grub1conf}",
    changes => [
      'rm hiddenmenu',

      'rm serial',
      'ins serial before title[1]',
      "set serial/unit ${ttys_id}",
      "set serial/speed ${speed}",

      'rm terminal',
      'ins terminal before title[1]',
      "set terminal/timeout ${timeout}",
      'ins console after terminal/timeout', # 2.
      'ins serial after terminal/timeout', # 1.
    ],
  }
}
