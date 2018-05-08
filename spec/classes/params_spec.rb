require 'spec_helper'

describe 'hp_sdr::params' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('hp_sdr::params') }
      it { is_expected.to have_resource_count(0) }
    end

    context "on #{os} with invalid manufacturer" do
      let(:facts) do
        os_facts.merge(
          'dmi' => {
            'manufacturer' => 'Unknown',
          },
        )
      end

      it { is_expected.not_to compile }
    end
  end
end
