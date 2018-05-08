# Puppet module for HP SDR setup

[![Puppet Forge](http://img.shields.io/puppetforge/v/vholer/hp_sdr.svg)](https://forge.puppetlabs.com/vholer/hp_sdr)

This module configures client for
[HP Service Delivery Repositories](http://downloads.linux.hp.com/SDR/index.html).

### Requirements

Module has been tested on:

* Puppet 5.5.1
* OS:
  * RHEL/CentOS 7
  * Debian 8, 9

Required modules:

* [puppetlabs-stdlib](https://forge.puppet.com/puppetlabs/stdlib)
* [puppetlabs-apt](https://forge.puppet.com/puppetlabs/apt)
* [puppet-yum](https://forge.puppet.com/puppet/yum)
* [puppet-zypprepo](https://forge.puppet.com/puppet/zypprepo)

# Quick Start

There are predefined classes for common repositories:

* `hp_sdr::spp` (Service Pack for ProLiant)
* `hp_sdr::mcp` (Management Component Pack for ProLiant)
* `hp_sdr::isp` (Integrity Support Pack)
* `hp_sdr::iwbem` (Integrity WBEM Providers)
* `hp_sdr::mlnx_ofed` (Mellanox OFED VPI Drivers and Utilities)
* `hp_sdr::vibsdepot` (VMware® ESXi bundles)
* `hp_sdr::hpsum` (HP Smart Update Manager)
* `hp_sdr::stk` (HP ProLiant Scripting Toolkit)

```puppet
include hp_sdr::spp
include hp_sdr::mcp
include hp_sdr::isp
include hp_sdr::iwbem
include hp_sdr::mlnx_ofed
include hp_sdr::vibsdepot
include hp_sdr::hpsum
include hp_sdr::stk
```

Full configuration options:

```puppet
class { 'hp_sdr::spp':
  ensure   => present|absent,  # ensure state
  gpgcheck => true|false,      # check GPG signatures
  dist     => '...',           # OS code name
  release  => '...',           # OS version
  arch     => '...',           # OS architecture
  version  => 'current',       # HP bundle version
  url_base => '...',           # URL base part
  url_repo => '...',           # URL repo. specific part
}
```

# Contributors

* Håkon Heggernes Lerring <hakon@powow.no>
* Siebrand Mazeland <siebrand@kitano.nl>
* Kim Jahn <kim@maisspace.org>
* Jonathan Araña Cruz <jonhattan@faita.net>
