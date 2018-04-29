define hp_sdr::repo (
  $dist,
  $release,
  $arch,
  $project_ver,
  $url_base,
  $url_repo,
  $bundle     = $title,
  $keys_stage = main,
  $ensure     = present,
  $gpgcheck   = 1
) {
  validate_string($release, $project_ver, $url_base, $url_repo, $bundle)

  unless $gpgcheck in [0,1] {
    fail("Invalid \$gpgcheck value: ${gpgcheck}")
  }

  unless $ensure in [present,absent] {
    fail("Invalid ensure state: ${ensure}")
  }

  if ! defined( Class['hp_sdr::keys'] ) {
    class { 'hp_sdr::keys':
      stage => $keys_stage,
    }
  }

  $_url = inline_template("${url_base}/${url_repo}")
  $_name = "HP-${bundle}"
  $_descr = "HP Software Delivery Repository for ${bundle}"

  case $::osfamily {
    redhat: {
      yumrepo { $_name:
        ensure   => $ensure,
        enabled  => 1,
        gpgcheck => $gpgcheck,
        descr    => $_descr,
        baseurl  => $_url,
        require  => Class['hp_sdr::keys'],
      }
    }

    suse: {
      $_enabled = $ensure ? {
        present => 1,
        default => absent,
      }

      zypprepo { $_name:
        enabled      => $_enabled,
        gpgcheck     => $gpgcheck,
        descr        => $_descr,
        baseurl      => $_url,
        type         => 'rpm-md',
        autorefresh  => 1,
        keeppackages => 0,
        require  => Class['hp_sdr::keys'],
      }
    }

    debian: {
      apt::source { $_name:
        ensure   => $ensure,
        location => $_url,
        release  => "${release}/${project_ver}",
        repos    => 'non-free',
        require  => Class['hp_sdr::keys'],
      }
    }

    default: {
      fail("Unsupported OS: ${::operatingsystem}")
    }
  }
}
