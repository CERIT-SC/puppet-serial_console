class serial_console::refresh {
  unless empty($::serial_console::cmd_refresh_init) {
    exec { 'serial_console-refresh-init':
      command     => $::serial_console::cmd_refresh_init,
      refreshonly => true,
    }
  }

  unless empty($::serial_console::cmd_refresh_bootloader) {
    exec { 'serial_console-refresh-bootloader':
      command     => $::serial_console::cmd_refresh_bootloader,
      refreshonly => true,
    }
  }
}
