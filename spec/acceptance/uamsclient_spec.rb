require 'spec_helper_acceptance'

describe 'uamsclient class' do
  context 'with specific parameters' do
    let(:manifest) do
      <<-EOS
      class { 'uamsclient':
        uams_access_token  => 'uams_access_token',
        swo_url            => 'na-01.st-ssp.solarwinds.com',
        uams_metadata      => 'role:host-monitoring',
        dev_container_test => true,
      }
      EOS
    end

    it 'applies the manifest without error' do
      apply_manifest(manifest, catch_failures: false)
    end

    it 'is idempotent' do
      apply_manifest(manifest, catch_changes: true)
    end

    describe package('uamsclient') do
      it { is_expected.to be_installed }
    end

    describe file('/opt/solarwinds/uamsclient/sbin/uamsclient') do
      it { is_expected.to exist }
      it { is_expected.to be_file }
      it { is_expected.to be_executable }
    end
  end
end
