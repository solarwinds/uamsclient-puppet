# Puppet UAMS Client Module

The Puppet UAMS Client module installs and configures the UAMS Client.

## Table of Contents

- [Puppet UAMS Client Module](#puppet-uams-client-module)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [Module Installation](#module-installation)
  - [Usage](#usage)
    - [UAMS Client Installation](#uams-client-installation)
      - [Parameters](#parameters)
    - [UAMS Client Uninstallation](#uams-client-uninstallation)
  - [Requirements](#requirements)
    - [Dependencies](#dependencies)
  - [Contributing](#contributing)

## Description

The uamsclient Puppet module is designed to install and configure the SolarWinds Observability Agent on supported operating systems. This agent enables host monitoring, which collects data about the performance, stability, and overall health of your hosts. By utilizing this module, administrators can monitor both cloud-based virtual machines and standard servers, ensuring proactive issue resolution and service planning.

## Setup

To set up the uamsclient Puppet module, define the class with the necessary parameters to install and configure the SolarWinds Observability Agent on your host.

### Module Installation
To install the uamsclient module, you can use the following command:

```bash
puppet module install solarwinds-uamsclient
```

## Usage

Usage of the UAMS Client Puppet module.

### UAMS Client Installation

To install the UAMS Client agent using this module, you need to define the class `uamsclient` with the appropriate parameters. Below is an example of how to use this module to install the UAMS Client:

```puppet
class { 'uamsclient':
    uams_access_token => '<uams_access_token>',
    swo_url           => 'na-01.cloud.solarwinds.com',
    uams_metadata     => 'role:host-monitoring',
}
```

#### Parameters
 - `uams_access_token`: This is the access token required for authenticating with the UAMS service. You must replace '<uams_access_token>' with your actual UAMS access token.
 - `swo_url`: This is the URL endpoint for the UAMS service. The default URL is 'na-01.cloud.solarwinds.com', but you can replace it with the appropriate URL for your region or service.
 - `uams_metadata`: This is the metadata used for identifying the role and purpose of the host. To enable basic host monitoring, the `uams_metadata` variable should contain 'role:host-monitoring'.
 - `uams_override_hostname`: Optional variable to set a custom Agent name. By default, the Agent name is set to the hostname.

### Managed Locally Agents
The variable `uams_managed_locally` is used to configure the Agent as managed locally through the configuration file. 
It is designed to allow configuration of the UAMS Agent locally, without the necessity of adding integrations manually from the SWO page.

If the UAMS Agent is installed as a **managed locally** agent, it will wait for the local configuration file to be accessible. The default local configuration is `/opt/solarwinds/uamsclient/var/local_config.yaml`.

An additional optional configuration file `credentials_config.yaml` can be used to define credentials providers. This file can be used in conjunction with `local_config.yaml` to retrieve a credential from a defined credential provider.

Puppet will automatically copy both files (`credentials_config.yaml` and `local_config.yaml`) to the needed location. The default templates of these files are located at `templates/local_config.yaml.epp` and `templates/credentials_config.yaml.epp` respectively.

You can use Puppet template syntax to fill the template with appropriate variables. To assign values to variables in the template, you can fill the Hash type variables `local_config_template_parameters` and `credentials_config_template_parameters` as in the example below.

```puppet
class { 'uamsclient':
    uams_access_token                  => '<uams_access_token>',
    swo_url                            => 'na-01.cloud.solarwinds.com',
    uams_metadata                      => 'role:host-monitoring',
    uams_managed_locally               => true,
    local_config_template_parameters   => {
      mysql_host  =>  'test_mysql_host',
      user        =>  'test_mysql_user',
      secret_name =>  'test_secret_name',
  },
    credentials_config_template_parameters => {
      access_key_id     =>  'your_access_key_id',
      secret_access_key =>  'your_secret_access_key',
  }
}
```

To learn more about building the appropriate local config, check out the official documentation.

### UAMS Client Uninstallation

If you need to uninstall the UAMS Client agent, you can use the `uamsclient::uninstall` class. This class will remove the UAMS Client package and ensure that related files and services are no longer present on the system. Below is an example of how to use this module to uninstall the UAMS Client:

```puppet
class { 'uamsclient::uninstall': }
```

## Requirements

* Puppet 7 or later

SolarWinds Observability Agents work on most systems. The following lists the platforms that have been tested and verified to work with the Agents:

 - Amazon Linux 2 and later
 - CentOS 6 and later
 - Debian 10 and later
 - Fedora 32 and later
 - Kali 2021 and later
 - OpenSUSE 15 and later
 - Oracle Linux 8 and later
 - RedHat 7.1 and later
 - Rocky Linux 8 and later
 - SUSE Linux Enterprise Server 15 and later
 - Ubuntu 18.04 and later

More information about agent system requirements can be found [here](https://documentation.solarwinds.com/en/success_center/observability/content/system_requirements/host_requirements.htm).

### Dependencies

 - puppetlabs-stdlib: >=4.25.0 <10.0.0

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for more details.