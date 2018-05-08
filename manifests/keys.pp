# hp_sdr::keys
#
# Import HP signing keys for packages/repositories.
#
# @summary Import HP signing keys.
#
# @param keys Structure with keys and their names, filenames and IDs
#
# @example
#   include hp_sdr::keys
class hp_sdr::keys (
  Hp_sdr::Keys $keys = $hp_sdr::params::keys,
) inherits hp_sdr::params {

  $keys.each |$_name, $_meta| {
    case $facts['os']['family'] {
      'RedHat', 'Suse': {
        yum::gpgkey { $_meta['path']:
          content => $_meta['key'],
        }
      }

      'Debian': {
        unless defined(Class['apt']) {
          include apt
        }

        apt::key { $_name:
          id      => $_meta['id'],
          content => $_meta['key'],
        }
      }

      default: {
        fail("Unsupported OS family: ${facts['os']['family']}")
      }
    }
  }
}
