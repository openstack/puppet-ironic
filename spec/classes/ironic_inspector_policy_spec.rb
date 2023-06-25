require 'spec_helper'

describe 'ironic::inspector::policy' do
  shared_examples 'ironic::inspector::policy' do

    context 'setup policy with parameters' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/ironic-inspector/policy.yaml',
          :policy_default_rule  => 'default',
          :policy_dirs          => '/etc/ironic-inspector/policy.d',
          :policies             => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          }
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/ironic-inspector/policy.yaml').with(
          :policies     => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          },
          :policy_path  => '/etc/ironic-inspector/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'ironic-inspector',
          :file_format  => 'yaml',
          :purge_config => false,
          :tag          => 'ironic-inspector',
        )
        is_expected.to contain_oslo__policy('ironic_inspector_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/ironic-inspector/policy.yaml',
          :policy_default_rule  => 'default',
          :policy_dirs          => '/etc/ironic-inspector/policy.d',
        )
      end
    end

    context 'with empty policies and purge_config enabled' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/ironic-inspector/policy.yaml',
          :policies             => {},
          :purge_config         => true,
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/ironic-inspector/policy.yaml').with(
          :policies     => {},
          :policy_path  => '/etc/ironic-inspector/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'ironic-inspector',
          :file_format  => 'yaml',
          :purge_config => true,
          :tag          => 'ironic-inspector',
        )
        is_expected.to contain_oslo__policy('ironic_inspector_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/ironic-inspector/policy.yaml',
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'ironic::inspector::policy'
    end
  end
end
