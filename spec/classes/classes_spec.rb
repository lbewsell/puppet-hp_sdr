require 'spec_helper'

PUPPET_CLASSES = %w[
  hpsum
  isp
  iwbem
  mcp
  mlnx_ofed
  spp
  stk
  vibsdepot
].freeze

PUPPET_CLASSES.each do |puppet_class|
  describe "hp_sdr::#{puppet_class}" do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        it { is_expected.to compile }
        it { is_expected.to contain_class("hp_sdr::#{puppet_class}") }
        it { is_expected.to contain_hp_sdr__repo(puppet_class) }
      end

      context "on #{os} with other classes" do
        let(:facts) { os_facts }
        let(:post_condition) do
          'include ' + PUPPET_CLASSES.map { |p| "hp_sdr::#{p}" }.join(',')
        end

        it { is_expected.to compile }

        PUPPET_CLASSES.each do |p|
          it { is_expected.to contain_class("hp_sdr::#{p}") }
          it { is_expected.to contain_hp_sdr__repo(p) }
        end
      end

      context "on #{os} with custom params" do
        let(:facts) { os_facts }
        let(:params) do
          {
            'ensure'   => 'absent',
            'version'  => 'my_version',
            'gpgcheck' => false,
            'dist'     => 'my_dist',
            'release'  => 'my_release',
            'arch'     => 'my_arch',
            'url_base' => 'http://my_url_base',
            'url_repo' => 'my_url_repo',
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_class("hp_sdr::#{puppet_class}") }

        it {
          is_expected.to contain_hp_sdr__repo(puppet_class).with(
            'ensure'   => 'absent',
            'version'  => 'my_version',
            'gpgcheck' => false,
            'dist'     => 'my_dist',
            'release'  => 'my_release',
            'arch'     => 'my_arch',
            'url_base' => 'http://my_url_base',
            'url_repo' => 'my_url_repo',
          )
        }
      end
    end
  end
end
