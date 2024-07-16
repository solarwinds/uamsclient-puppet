# @summary Defines a environment variables
#
# @param variable_name
#   Name of environment variable
# @param value
#   Value of environment variable
# @param ensure
#   Sets or deletes the specified environment variable
#
define uamsclient::environment_variable (
  String $variable_name,
  String $value,
  Enum['absent', 'present'] $ensure = present
) {
  include stdlib

  $env_file_path = '/etc/environment'

  file_line { "${variable_name}_${ensure}":
    ensure => $ensure,
    path   => $env_file_path,
    line   => "${variable_name}=${value}",
    match  => "^${variable_name}=",
  }
}
