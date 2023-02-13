require 'spec_helper'

describe 'ironic::inventory' do

  shared_examples_for 'ironic::inventory' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it 'configures default values' do
        is_expected.to contain_ironic_config('inventory/data_backend').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('inventory/swift_data_container').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :data_backend         => 'database',
          :swift_data_container => 'introspection_data_container'
        }
      end

      it 'configures specified values' do
        is_expected.to contain_ironic_config('inventory/data_backend').with_value('database')
        is_expected.to contain_ironic_config('inventory/swift_data_container').with_value('introspection_data_container')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'ironic::inventory'
    end
  end

end
