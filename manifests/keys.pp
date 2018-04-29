class hp_sdr::keys (
  $gpg_key1      = $hp_sdr::params::gpg_key1,
  $gpg_key1_path = $hp_sdr::params::gpg_key1_path,
  $gpg_key1_id   = $hp_sdr::params::gpg_key1_id,
  $gpg_key2      = $hp_sdr::params::gpg_key2,
  $gpg_key2_path = $hp_sdr::params::gpg_key2_path,
  $gpg_key2_id   = $hp_sdr::params::gpg_key2_id,
  $gpg_key3      = $hp_sdr::params::gpg_key3,
  $gpg_key3_path = $hp_sdr::params::gpg_key3_path,
  $gpg_key3_id   = $hp_sdr::params::gpg_key3_id,
  $gpg_key4      = $hp_sdr::params::gpg_key4,
  $gpg_key4_path = $hp_sdr::params::gpg_key4_path,
  $gpg_key4_id   = $hp_sdr::params::gpg_key4_id
) inherits hp_sdr::params {

  validate_string($gpg_key1, $gpg_key1_id)
  validate_string($gpg_key2, $gpg_key2_id)
  validate_string($gpg_key3, $gpg_key3_id)
  validate_string($gpg_key4, $gpg_key4_id)

  case $::osfamily {
    redhat,suse: {
      validate_absolute_path($gpg_key1_path, $gpg_key2_path, $gpg_key3_path, $gpg_key4_path)

      yum::gpgkey { $gpg_key1_path:
        content => $gpg_key1,
      }

      yum::gpgkey { $gpg_key2_path:
        content => $gpg_key2,
      }

      yum::gpgkey { $gpg_key3_path:
        content => $gpg_key3,
      }

      yum::gpgkey { $gpg_key4_path:
        content => $gpg_key4,
      }
    }

    debian,ubuntu: {
      apt::key { 'hpPublicKey1':
        key         => $gpg_key1_id,
        key_content => $gpg_key1,
      }

      apt::key { 'hpPublicKey2':
        key         => $gpg_key2_id,
        key_content => $gpg_key2,
      }

      apt::key { 'hpPublicKey3':
        key         => $gpg_key3_id,
        key_content => $gpg_key3,
      }

      apt::key { 'hpPublicKey4':
        key         => $gpg_key4_id,
        key_content => $gpg_key4,
      }
    }

    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }
}
