# @summary Class for preparing container environment for tests
class uamsclient::container {
  $os_name = $facts['os']['name']

  if $os_name in ['SLES',] {
    package { 'sudo':
      ensure   => 'installed',
    }
  }
}
