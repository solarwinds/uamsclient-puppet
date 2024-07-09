# frozen_string_literal: true

require 'spec_helper'

describe 'uamsclient' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'uams_access_token' => 'mocked_token_value',
          'swo_url' => 'mocked_swo_url'
        }
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
