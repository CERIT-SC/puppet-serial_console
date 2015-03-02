class serial_console::kernel::grub2 (
  $tty,
  $ttys,
  $speed
) {
  if $tty {
    $value = [$tty, "${ttys},${speed}"]
  } else {
    $value = ["${ttys},${speed}"]
  }

  kernel_parameter { 'console':
    ensure   => present,
    value    => $value,
    provider => 'grub2',
  }

  # cleanup
  augeas { 'grub2_linux_default_cleanup':
    incl    => '/etc/default/grub',
    lens    => 'Shellvars.lns',
    context => '/files/etc/default/grub',
    notify  => Class['serial_console::refresh'], #???
    changes => [
      'rm #comment[. = "Puppet GRUB_CMDLINE_LINUX_DEFAULT console"]',
      "rm GRUB_CMDLINE_LINUX_DEFAULT[. = '\"\${GRUB_CMDLINE_LINUX_DEFAULT} console=tty0 console=${ttys},115200\"']",
    ],
  }
}
