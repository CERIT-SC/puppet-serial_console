# Fact: serialports
# Fact: usbserialports
#
# Purpose: comma separated list of (USB) serial devices
#
# Resolution:
#   Detects device names (without /dev/ prefix) of
#   the (USB) serial devices. Return as comma
#   separated string.
#
# Caveats:
#   Curently only Linux is supported.
#
Facter.add("serialports") do
  confine :kernel => :linux
  setcode do
    fn = '/proc/tty/driver/serial'
    if File.exists?(fn) 
      ports = []
      File.open(fn).each do |line|
        # serinfo:1.0 driver revision:
        # 0: uart:16550A port:000003F8 irq:4 tx:0 rx:0
        # 1: uart:16550A port:000002F8 irq:3 tx:6574 rx:0 RTS|DTR
        # 2: uart:unknown port:000003E8 irq:4
        # 3: uart:unknown port:000002E8 irq:3
        if (line =~ /^(\d+): uart:(\w+) /) and ($2 != 'unknown')
          ports << "ttyS#{$1}"
        end
      end

      unless ports.empty?
        ports.join(',')
      end
    end
  end
end

Facter.add("usbserialports") do
  confine :kernel => :linux
  setcode do
    fn = '/proc/tty/driver/usbserial'
    if File.exists?(fn) 
      ports = []
      File.open(fn).each do |line|
        # usbserinfo:1.0 driver:2.0
        # 0: module:usb_serial_simple name:"suunto" vendor:0fcf product:1008 num_ports:1 port:0 path:usb-0000:00:1a.0-1.1.1.2
        # 1: module:pl2303 name:"pl2303" vendor:0557 product:2008 num_ports:1 port:0 path:usb-0000:00:1a.0-1.1.1.3
        if line =~ /^(\d+): module:/
          ports << "ttysUSB#{$1}"
        end
      end

      unless ports.empty?
        ports.join(',')
      end
    end
  end
end
