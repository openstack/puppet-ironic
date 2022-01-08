require 'spec_helper'

describe 'ironic::inspector::config' do
  let :params do
    {
      :ironic_inspector_config => {
        'DEFAULT/foo' => { 'value'  => 'fooValue' },
        'DEFAULT/bar' => { 'value'  => 'barValue' },
        'DEFAULT/baz' => { 'ensure' => 'absent' }
      }
    }
  end

  shared_examples 'ironic::inspector::config' do
    it { should contain_class('ironic::deps') }

    it {
      should contain_ironic_inspector_config('DEFAULT/foo').with_value('fooValue')
      should contain_ironic_inspector_config('DEFAULT/bar').with_value('barValue')
      should contain_ironic_inspector_config('DEFAULT/baz').with_ensure('absent')
    }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'ironic::inspector::config'
    end
  end
end
