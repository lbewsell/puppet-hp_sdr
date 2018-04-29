class hp_sdr::params {
  $stage = main
  $ensure = present
  $gpgcheck = 1

  # http://downloads.linux.hp.com/SDR/keys.html
  $gpg_key1 = template('hp_sdr/hpPublicKey1024.pub.erb')
  $gpg_key1_id = 'FB410E68CEDF95D066811E95527BC53A2689B887'
  $gpg_key2 = template('hp_sdr/hpPublicKey2048.pub.erb')
  $gpg_key2_id = '476DADAC9E647EE27453F2A3B070680A5CE2D476'
  $gpg_key3 = template('hp_sdr/hpPublicKey2048_key1.pub.erb')
  $gpg_key3_id = '882F7199B20F94BD7E3E690EFADD8D64B1275EA3'
  $gpg_key4 = template('hp_sdr/hpePublicKey2048_key1.pub.erb')
  $gpg_key4_id = '57446EFDE098E5C934B69C7DC208ADDE26C2B797'

  $project_ver = 'current'
  $url_base = 'http://downloads.linux.hpe.com/SDR/repo'

  case $::osfamily {
    redhat: {
      $gpg_key1_path = '/etc/pki/rpm-gpg/RPM-GPG-KEY-hpPublicKey1'
      $gpg_key2_path = '/etc/pki/rpm-gpg/RPM-GPG-KEY-hpPublicKey2'
      $gpg_key3_path = '/etc/pki/rpm-gpg/RPM-GPG-KEY-hpPublicKey3'
      $gpg_key4_path = '/etc/pki/rpm-gpg/RPM-GPG-KEY-hpePublicKey1'

      $url_repo = '<%= @bundle %>/<%= @dist %>/<%= @release %>/<%= @arch %>/<%= @project_ver %>'
      $arch = '$basearch'
      $release = '$releasever'

      case $::operatingsystem {
        redhat,centos:  { $dist = downcase($::operatingsystem) }
        scientific,slc: { $dist = 'centos' }
        oraclelinux:    { $dist = 'oracle' }
        default:        { fail("Unsupported OS: ${::operatingsystem}") }
      }
    }

    suse: {
      $gpg_key1_path = '/etc/pki/RPM-GPG-KEY-hpPublicKey1'
      $gpg_key2_path = '/etc/pki/RPM-GPG-KEY-hpPublicKey2'
      $gpg_key3_path = '/etc/pki/RPM-GPG-KEY-hpPublicKey3'
      $gpg_key4_path = '/etc/pki/RPM-GPG-KEY-hpePublicKey1'

      $url_repo = '<%= @bundle %>/suse/<%= @release %>/<%= @arch %>/<%= @project_ver %>'
      $arch = $::architecture

      case $::operatingsystem {
        sles,sled: {
          $version = regsubst($::operatingsystemrelease, '\.', '-SP')
          $release = "SLES${version}"
        }

        default: {
          fail("Unsupported OS: ${::operatingsystem}")
        }
      }
    }

    debian: {
      $url_repo = '<%= @bundle %>'
      $release = $::lsbdistcodename

      unless $::operatingsystem in ['Debian','Ubuntu'] {
        fail("Unsupported OS: ${::operatingsystem}")
      }
    }

    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }

  # check for HP hardware
  unless $::manufacturer == 'HP' {
    fail("Unsupported manufacturer: ${::manufacturer}")
  }
}
