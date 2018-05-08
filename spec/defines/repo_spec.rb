require 'spec_helper'

describe 'hp_sdr::repo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'foo' }
      let(:params) do
        {
          'ensure'   => 'present',
          'dist'     => 'centos',
          'release'  => '7',
          'arch'     => 'x86_64',
          'version'  => 'current',
          'url_base' => 'http://repobase',
          'url_repo' => 'prefix/<%= $bundle %>/<%= $dist %>/<%= $release %>/<%= $arch %>/<%= $version %>',
          'gpgcheck' => false,
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('hp_sdr::keys') }

      case os_facts[:os]['family']
      when 'RedHat'
        it {
          is_expected.to contain_yumrepo('HP-foo').with(
            'ensure'   => 'present',
            'enabled'  => 1,
            'gpgcheck' => 0,
            'baseurl'  => 'http://repobase/prefix/foo/centos/7/x86_64/current',
          )
        }
      when 'Suse'
        it {
          is_expected.to contain_zypprepo('HP-foo').with(
            'enabled'      => 1,
            'gpgcheck'     => 0,
            'baseurl'      => 'http://repobase/prefix/foo/centos/7/x86_64/current',
            'type'         => 'rpm-md',
            'autorefresh'  => 1,
            'keeppackages' => 0,
          )
        }
      when 'Debian'
        it {
          is_expected.to contain_apt__source('HP-foo').with(
            'ensure'         => 'present',
            'allow_unsigned' => true,
            'location'       => 'http://repobase/prefix/foo/centos/7/x86_64/current',
            'release'        => '7/current',
            'repos'          => 'non-free',
          )
        }
      end
    end

    context "on #{os} disabled" do
      let(:facts) { os_facts }
      let(:title) { 'foo' }
      let(:params) do
        {
          'ensure'   => 'absent',
          'dist'     => 'centos',
          'release'  => '7',
          'arch'     => 'x86_64',
          'version'  => 'current',
          'url_base' => 'http://repobase',
          'url_repo' => 'prefix/<%= $bundle %>/<%= $dist %>/<%= $release %>/<%= $arch %>/<%= $version %>',
          'gpgcheck' => true,
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('hp_sdr::keys') }

      case os_facts[:os]['family']
      when 'RedHat'
        it {
          is_expected.to contain_yumrepo('HP-foo').with(
            'ensure'   => 'absent',
            'gpgcheck' => 1,
          )
        }
      when 'Suse'
        it {
          is_expected.to contain_zypprepo('HP-foo').with(
            'enabled'  => 'absent',
            'gpgcheck' => 1,
          )
        }
      when 'Debian'
        it {
          is_expected.to contain_apt__source('HP-foo').with(
            'ensure'         => 'absent',
            'allow_unsigned' => false,
          )
        }
      end
    end
  end
end
