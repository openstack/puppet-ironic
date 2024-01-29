require 'spec_helper'

describe 'ironic::reports' do
  shared_examples 'ironic::reports' do
    context 'with default parameters' do
      it {
        is_expected.to contain_oslo__reports('ironic_config').with(
          :log_dir                     => '<SERVICE DEFAULT>',
          :file_event_handler          => '<SERVICE DEFAULT>',
          :file_event_handler_interval => '<SERVICE DEFAULT>',
          :package_ensure              => 'present',
          :manage_package              => true,
        )
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :log_dir                     => '/var/log/ironic',
          :file_event_handler          => '/var/tmp/ironic/reports',
          :file_event_handler_interval => 1,
        }
      end

      it {
        is_expected.to contain_oslo__reports('ironic_config').with(
          :log_dir                     => '/var/log/ironic',
          :file_event_handler          => '/var/tmp/ironic/reports',
          :file_event_handler_interval => 1,
        )
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'ironic::reports'
    end
  end
end
