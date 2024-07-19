# @summary Class for UAMS Client uninstallation
#
# @param uams_local_pkg_path
#   Path to temporary UAMS directory
# @param dev_container_test
#   Indicates if it is a container installation
class uamsclient::uninstall (
  String[1] $uams_local_pkg_path = $uamsclient::params::uams_local_pkg_path,
  Boolean $dev_container_test    = $uamsclient::params::dev_container_test,
) inherits uamsclient::params {
  package { 'uamsclient':
    ensure   => absent,
  }

  file { $uams_local_pkg_path:
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  unless $dev_container_test {
    service { 'uamsclient':
      ensure => 'stopped',
      enable => false,
    }
  }
}
