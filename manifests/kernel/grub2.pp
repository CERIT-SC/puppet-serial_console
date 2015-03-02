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

  # Augeas didn't load /etc/default/grub with Shellvars_list.lns on
  # GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
  exec { 'grub-fix-subst':
    command => 'sed -i -e \'s/=\(`.*`\)$/="\1"/\' /etc/default/grub',
    onlyif  => 'grep -F \'=`\' /etc/default/grub',
    path    => '/bin:/usr/bin',
  }

  kernel_parameter { 'console':
    ensure   => present,
    value    => $value,
    provider => 'grub2',
    require  => Exec['grub-fix-subst'],
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
