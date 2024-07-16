# @summary Class containing default settings according to operating system
#
class uamsclient::params {
  ### Operating System Configuration
  $_module_defaults = {
    'uams_local_pkg_path'        => '/tmp/uams',
    'install_pkg_url'            => 'https://agent-binaries.cloud.solarwinds.com/uams/latest',
    'dev_container_test'         => false,
    'uamsclient_work_dir'        => '/opt/solarwinds/uamsclient/etc/',
    'uamsclient_ctl'             => '/opt/solarwinds/uamsclient/sbin/uamsclient-ctl',
  }

  case $facts['os']['family'] {
    'Debian': {
      $_module_os_overrides = {
        'placeholder' => 'placeholder',
      }
    }
    'RedHat': {
      $_module_os_overrides = {
        'placeholder' => 'placeholder',
      }
    }
    default: {
      $_module_os_overrides = {}
    }
  }

  $_module_parameters = $_module_defaults + $_module_os_overrides
  ### END Operating System Configuration

  ### Referenced Variables
  $uams_local_pkg_path      = $_module_parameters['uams_local_pkg_path']
  $install_pkg_url          = $_module_parameters['install_pkg_url']
  $dev_container_test       = $_module_parameters['dev_container_test']
  $uamsclient_work_dir      = $_module_parameters['uamsclient_work_dir']
  $uamsclient_ctl           = $_module_parameters['uamsclient_ctl']
  ### END Referenced Variables
}
