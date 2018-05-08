require 'spec_helper'

describe 'hp_sdr::keys' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('hp_sdr::keys') }
    end

    context "on #{os} with no keys" do
      let(:facts) { os_facts }
      let(:params) { { 'keys' => {} } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('hp_sdr::keys') }
      it { is_expected.to have_resource_count(0) }
    end

    context "on #{os} with custom keys" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'keys' => {
            'mykey1' => {
              'id'   => '1' * 40,
              'key'  => 'content1',
              'path' => '/tmp/mykey1',
            },
            'mykey2' => {
              'id'   => '2' * 40,
              'key'  => 'content2',
              'path' => '/tmp/mykey2',
            },
          },
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('hp_sdr::keys') }

      case os_facts[:os]['family']
      when 'RedHat', 'Suse'
        it {
          is_expected.to contain_yum__gpgkey('/tmp/mykey1').with(
            'content' => 'content1',
          )
        }

        it {
          is_expected.to contain_yum__gpgkey('/tmp/mykey2').with(
            'content' => 'content2',
          )
        }
      when 'Debian'
        it { is_expected.to contain_class('apt') }

        it {
          is_expected.to contain_apt__key('mykey1').with(
            'id'      => '1' * 40,
            'content' => 'content1',
          )
        }

        it {
          is_expected.to contain_apt__key('mykey2').with(
            'id'      => '2' * 40,
            'content' => 'content2',
          )
        }
      end
    end
  end
end
