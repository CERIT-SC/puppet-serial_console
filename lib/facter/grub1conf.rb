# Fact: grub1conf
#
# Purpose: return path to GRUB1 grub.conf
#
# Resolution:
#
# Caveats:
#
#
Facter.add("grub1conf") do
  confine :kernel => :linux
  setcode do
    value = nil
    ['/boot/grub/menu.lst','/etc/grub.conf'].each do |fn|
      if File.exists?(fn)
        value = fn
		break
      end
    end
    value
  end
end
