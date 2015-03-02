## 2015-03-02 - Release 0.9.6

### Summary

Fix unquoted substitutions in /etc/default/grub.

#### Bugfixes

- Fix unquoted substitutions in /etc/default/grub
  to prevent Augeas parse errors.

## 2015-03-02 - Release 0.9.5

### Summary

Change GRUB2 manipulation to kernel_parameter{}, allow to specify
non-serial tty console output, code refactoring. Fix device names
in $::usbserialports.

#### Features

- Change work with GRUB2 from augeas{} to kernel_parameter{}
- New option ($tty) to specify kernel console output to tty

#### Bugfixes

- Fix device names in fact $::usbserialports

## 2014-12-08 - Release 0.9.3

### Summary

Fix file/directory permissions.

#### Bugfixes

- Fix PF module archive file/directory permissions.

## 2014-10-02 - Release 0.9.2

### Summary

Remove deprecation warning on ERB

#### Bugfixes

- Remove deprevation warning from ERB

## 2014-09-02 - Release 0.9.1

### Summary

Fix metadata.json

#### Bugfixes

- Fix metadata.json module dependencies

## 2014-08-28 - Release 0.9.0

### Summary

Initial release.
