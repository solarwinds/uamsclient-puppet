# @summary Class for validation user inputs
class uamsclient::validate_inputs {
  $uams_access_token  = $uamsclient::uams_access_token
  $swo_url            = $uamsclient::swo_url

  # Validate 'uams_access_token' variable is not empty
  if $uams_access_token == undef or $uams_access_token == '' {
    fail('Variable \'uams_access_token\' is not set or is empty.')
  }

  # Validate 'swo_url' variable is not empty
  if $swo_url == undef or $swo_url == '' {
    fail('Variable \'swo_url\' is not set or is empty.')
  }
}
