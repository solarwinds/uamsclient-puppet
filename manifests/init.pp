# @summary Class for install and manage uamsclient
#
# Installs and configures UAMS Client
#
# @param uams_local_pkg_path
#   Path to temporary UAMS directory
# @param install_pkg_url
#   URL to UAMS Client installer
# @param dev_container_test
#   Indicates if it is a container installation
# @param uamsclient_work_dir
#   Path to UAMS Client workdir
# @param uamsclient_ctl
#   Path to uamsclient-ctl binary
# @param uams_access_token
#   UAMS Client access token
# @param swo_url
#   SWO URL to the desired endpoint
# @param uams_metadata
#   UAMS Client installation metadata
# @param uams_override_hostname
#   A customer client hostname. It is required if you want to set a specific agent hostname.
class uamsclient (
  String[1] $uams_local_pkg_path      = $uamsclient::params::uams_local_pkg_path,
  String[1] $install_pkg_url          = $uamsclient::params::install_pkg_url,
  Boolean $dev_container_test         = $uamsclient::params::dev_container_test,
  String[1] $uamsclient_work_dir      = $uamsclient::params::uamsclient_work_dir,
  String[1] $uamsclient_ctl           = $uamsclient::params::uamsclient_ctl,

  String[1] $uams_access_token                 = undef,
  String[1] $swo_url                           = undef,
  Optional[String[1]] $uams_metadata           = undef,
  Optional[String[1]] $uams_override_hostname  = undef,

) inherits uamsclient::params {
  include stdlib
  include uamsclient::validate_inputs
  include uamsclient::set_package_manager

  $pkg_type                 = $uamsclient::set_package_manager::pkg_type
  $pkg_manager              = $uamsclient::set_package_manager::pkg_manager

  if $dev_container_test {
    include uamsclient::container
  }

  file { $uams_local_pkg_path:
    ensure => directory,
    mode   => '0755',
  }

  file { "${uams_local_pkg_path}/uamsclient.${pkg_type}":
    ensure => file,
    source => "${install_pkg_url}/uamsclient.${pkg_type}",
    mode   => '0644',
  }

  exec { 'set_swo_url':
    command   => "${uamsclient_ctl} set-swo-url -work-dir ${uamsclient_work_dir} -url ${swo_url}",
    logoutput => true,
    path      => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    unless    => "cat ${uamsclient_work_dir}/dynamic_config.yaml | grep -q ${swo_url}",
    require   => [
      Package['uamsclient'],
    ],
  }

  exec { 'set_metadata':
    command   => "${uamsclient_ctl} set-metadata -work-dir ${uamsclient_work_dir} -md ${uams_metadata}",
    logoutput => true,
    path      => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    unless    => "cat ${uamsclient_work_dir}/dynamic_config.yaml | grep -q ${uams_metadata}",
    require   => [
      Package['uamsclient'],
    ],
  }

  exec { 'set_access_token':
    command     => "${uamsclient_ctl} set-access-token -work-dir ${uamsclient_work_dir} -token ${uams_access_token}",
    logoutput   => true,
    refreshonly => true,
    subscribe   => [
      Exec['set_swo_url'],
      Exec['set_metadata'],
    ],
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    require     => [
      Package['uamsclient'],
    ],
  }

  exec { 'set_override_hostname':
    command   => "${uamsclient_ctl} set-override-hostname -work-dir ${uamsclient_work_dir} -hostname ${uams_override_hostname}",
    logoutput => true,
    path      => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    require   => [
      Package['uamsclient'],
    ],
    unless    => [
      "cat ${uamsclient_work_dir}/dynamic_config.yaml | grep -q -E \"override-hostname: ${uams_override_hostname}$\"",
      "[ -z '${uams_override_hostname}']",
    ],
  }

  package { 'uamsclient':
    ensure   => 'installed',
    source   => "${uams_local_pkg_path}/uamsclient.${pkg_type}",
    provider => $pkg_manager,
    require  => [
      File["${uams_local_pkg_path}/uamsclient.${pkg_type}"],
    ],
  }

  unless $dev_container_test {
    service { 'uamsclient':
      ensure  => 'running',
      enable  => true,
      require => [
        Package['uamsclient'],
        Exec['set_swo_url'],
        Exec['set_access_token'],
        Exec['set_metadata'],
        Exec['set_override_hostname'],
      ],
    }
  }
}
