# hp_sdr::params
#
# Private class with module parameters.
#
# @summary Private class with module parameters.
class hp_sdr::params {
  # check for HP hardware
  unless ($facts['dmi']['manufacturer'] == 'HP') {
    fail("Unsupported manufacturer: ${facts['dmi']['manufacturer']}")
  }

  $ensure = present
  $version = 'current'
  $url_base = 'http://downloads.linux.hpe.com/SDR/repo'
  $gpgcheck = true

  # http://downloads.linux.hp.com/SDR/keys.html
  $_keys = {
    'hpPublicKey1'  => {
      'id'  => 'FB410E68CEDF95D066811E95527BC53A2689B887',
      'key' => epp('hp_sdr/hpPublicKey1024.pub.epp'),
    },
    'hpPublicKey2'  => {
      'id'  => '476DADAC9E647EE27453F2A3B070680A5CE2D476',
      'key' => epp('hp_sdr/hpPublicKey2048.pub.epp'),
    },
    'hpPublicKey3'  => {
      'id'  => '882F7199B20F94BD7E3E690EFADD8D64B1275EA3',
      'key' => epp('hp_sdr/hpPublicKey2048_key1.pub.epp'),
    },
    'hpePublicKey4' =>  {
      'id'  => '57446EFDE098E5C934B69C7DC208ADDE26C2B797',
      'key' => epp('hp_sdr/hpePublicKey2048_key1.pub.epp'),
    }
  }

  case $facts['os']['family'] {
    'RedHat': {
      $_keys_paths = {
        'hpPublicKey1'  => { 'path' => '/etc/pki/rpm-gpg/RPM-GPG-KEY-hpPublicKey1', },
        'hpPublicKey2'  => { 'path' => '/etc/pki/rpm-gpg/RPM-GPG-KEY-hpPublicKey2', },
        'hpPublicKey3'  => { 'path' => '/etc/pki/rpm-gpg/RPM-GPG-KEY-hpPublicKey3', },
        'hpePublicKey4' => { 'path' => '/etc/pki/rpm-gpg/RPM-GPG-KEY-hpePublicKey1', },
      }

      $url_repo = '<%= $bundle %>/<%= $dist %>/<%= $release %>/<%= $arch %>/<%= $version %>'
      $arch = '$basearch'
      $release = '$releasever'

      case $facts['os']['name'] {
        'RedHat', 'CentOS': { $dist = downcase($facts['os']['name']) }
        'Scientific':       { $dist = 'centos' }
        'OracleLinux':      { $dist = 'oracle' }
        default:            { fail("Unsupported OS: ${facts['os']['name']}") }
      }
    }

    'Suse': {
      $_keys_paths = {
        'hpPublicKey1'  => { 'path' => '/etc/pki/RPM-GPG-KEY-hpPublicKey1', },
        'hpPublicKey2'  => { 'path' => '/etc/pki/RPM-GPG-KEY-hpPublicKey2', },
        'hpPublicKey3'  => { 'path' => '/etc/pki/RPM-GPG-KEY-hpPublicKey3', },
        'hpePublicKey4' => { 'path' => '/etc/pki/RPM-GPG-KEY-hpePublicKey1', },
      }

      $url_repo = '<%= $bundle %>/suse/<%= $release %>/<%= $arch %>/<%= $version %>'
      $arch = pick(fact('os.architecture'), $::architecture)
      $dist = ''

      case $facts['os']['name'] {
        'SLES', 'SLED': {
          $_suse_version = regsubst($facts['os']['release']['full'], '\.', '-SP')
          $release = "SLES${_suse_version}"
        }

        default: {
          fail("Unsupported OS: ${facts['os']['name']}")
        }
      }
    }

    'Debian': {
      $_keys_paths = { }

      $url_repo = '<%= $bundle %>'
      $arch = ''
      $dist = ''
      $release = pick(fact('os.distro.codename'), $::lsbdistcodename)

      unless $facts['os']['name'] in ['Debian', 'Ubuntu'] {
        fail("Unsupported OS: ${facts['os']['name']}")
      }
    }

    default: {
      fail("Unsupported OS family: ${facts['os']['family']}")
    }
  }

  $keys = deep_merge($_keys, $_keys_paths)
}
