# hp_sdr::repo
#
# Defined resource to manage HP repository configuration.
#
# @summary Manage HP repository configuration.
#
# @param dist Distribution.
# @param release Release.
# @param arch Architecture.
# @param version Repository release version.
# @param url_base Base URL.
# @param url_repo Repository specific part of URL.
# @param bundle Repository name (defaults to $title)
# @param ensure Ensure state.
# @param gpgcheck GPG checking.
#
# @example
#   hp_sdr::repo { 'mcp':
#     ensure   => present,
#     dist     => 'centos',
#     release  => '$releasever',
#     arch     => '$arch',
#     version  => 'current',
#     url_base => 'http://downloads.linux.hpe.com/SDR/repo',
#     url_repo => '<%= $bundle %>/<%= $dist %>/<%= $release %>/<%= $arch %>/<%= $version %>',
#     gpgcheck => true,
#   }
define hp_sdr::repo (
  String $dist,
  String $release,
  String $arch,
  String[1] $version,
  String[1] $url_base,
  String[1] $url_repo,
  String[1] $bundle                 = $title,
  Enum['present', 'absent'] $ensure = present,
  Boolean $gpgcheck                 = true
) {
  require hp_sdr::keys

  $_url = inline_epp("${url_base}/${url_repo}")
  $_name = "HP-${bundle}"
  $_descr = "HP Software Delivery Repository for ${bundle}"

  case $facts['os']['family'] {
    'RedHat': {
      yumrepo { $_name:
        ensure   => $ensure,
        enabled  => 1,
        gpgcheck => bool2num($gpgcheck),
        descr    => $_descr,
        baseurl  => $_url,
      }
    }

    'Suse': {
      $_enabled = $ensure ? {
        present => 1,
        default => absent,
      }

      zypprepo { $_name:
        enabled      => $_enabled,
        gpgcheck     => bool2num($gpgcheck),
        descr        => $_descr,
        baseurl      => $_url,
        type         => 'rpm-md',
        autorefresh  => 1,
        keeppackages => 0,
      }
    }

    'Debian': {
      apt::source { $_name:
        ensure         => $ensure,
        allow_unsigned => ! $gpgcheck,
        location       => $_url,
        release        => "${release}/${version}",
        repos          => 'non-free',
      }
    }

    default: {
      fail("Unsupported OS family: ${facts['os']['family']}")
    }
  }
}
