class serial_console::kernel::grub2 (
  $ttys_name,
  $speed,
  $kargs_erb
) {
  $kargs = inline_template($kargs_erb)

  Augeas {
    incl    => '/etc/default/grub',
    lens    => 'Shellvars.lns',
    context => '/files/etc/default/grub',
    notify  => Class['serial_console::refresh'],
  }

  # create own settings line with identification comment
  augeas { 'grub2_linux_default_new':
    onlyif  => "match #comment[. = 'Puppet GRUB_CMDLINE_LINUX_DEFAULT console'] size == 0",
    changes => [
      "rm GRUB_CMDLINE_LINUX_DEFAULT[. = '\"\${GRUB_CMDLINE_LINUX_DEFAULT} ${kargs}\"']", #cleanup
      "set #comment[0] 'Puppet GRUB_CMDLINE_LINUX_DEFAULT console'",
      "set GRUB_CMDLINE_LINUX_DEFAULT[preceding-sibling::*[1] = 'Puppet GRUB_CMDLINE_LINUX_DEFAULT console'] \
'\"\${GRUB_CMDLINE_LINUX_DEFAULT} ${kargs}\"'",
    ],
  }

  # update previously created own settings line
  augeas { 'grub2_linux_default_set':
    require => Augeas['grub2_linux_default_new'],
    onlyif  => "match #comment[. = 'Puppet GRUB_CMDLINE_LINUX_DEFAULT console'] size > 0",
    changes => "set GRUB_CMDLINE_LINUX_DEFAULT[preceding-sibling::*[1] = 'Puppet GRUB_CMDLINE_LINUX_DEFAULT console'] \
'\"\${GRUB_CMDLINE_LINUX_DEFAULT} ${kargs}\"'",
  }
}
