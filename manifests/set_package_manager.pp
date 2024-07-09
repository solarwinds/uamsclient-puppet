# @summary Class for determining the package manager and package type for the OS.
#
class uamsclient::set_package_manager {
  $os_family = $facts['os']['family']
  $os_name = $facts['os']['name']
  $os_release = $facts['os']['release']['full']
  $os_version = $facts['os']['release']['major']

  if $os_name in ['Debian', 'Ubuntu', 'Kali'] {
    $pkg_type = 'deb'
    $pkg_manager = 'apt'
    # $command_if_uams_installed = 'dpkg-query -l uamsclient | tail -n1 | awk \'{print $3}\' | cut -d- -f1'
  } elsif $os_name in ['SLES',] {
    $pkg_type = 'rpm'
    $pkg_manager = 'rpm'
    # $command_if_uams_installed = 'dpkg-query -l uamsclient | tail -n1 | awk \'{print $3}\' | cut -d- -f1'
  } elsif $os_name in ['RedHat', 'CentOS', 'Fedora', 'OracleLinux', 'Amazon', 'Rocky'] {
    $pkg_type = 'rpm'
    if $os_name == 'Fedora' or
    ($os_name in ['CentOS', 'RedHat'] and Integer($os_version) > 7) or
    ($os_name == 'Amazon' and Integer($os_version) > 2000) {
      $pkg_manager = 'dnf'
      # $command_if_uams_installed = 'dnf list --installed | grep uams | awk \'{print $2}\' | cut -f1 -d-'
    } elsif $os_name in ['OracleLinux', 'Rocky'] or
    ($os_name in ['CentOS', 'RedHat'] and Integer($os_version) < 8) or
    ($os_name == 'Amazon' and Integer($os_version) < 2000) {
      $pkg_manager = 'yum'
      # $command_if_uams_installed = 'yum list | grep uamsclient | awk \'{print $2}\' | cut -f1 -d-'
    } else {
      fail("Could not determine installation package manager for ${os_name} ${os_version}.")
    }
  } else {
    fail("Unsupported OS: ${os_name} ${os_version}.")
  }

  # notify { 'Package Manager Detection':
  #   message => "OS Name: ${os_name}, OS Version: ${os_version}, type: ${pkg_type} Package Manager: ${pkg_manager}",
  # }
}
