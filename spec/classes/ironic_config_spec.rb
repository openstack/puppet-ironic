require 'spec_helper'

describe 'ironic::config' do

  let :params do
    { :ironic_config => {
        'DEFAULT/foo' => { 'value'  => 'fooValue' },
        'DEFAULT/bar' => { 'value'  => 'barValue' },
        'DEFAULT/baz' => { 'ensure' => 'absent' }
      }
    }
  end

  it 'configures arbitrary ironic configurations' do
    is_expected.to contain_ironic_config('DEFAULT/foo').with_value('fooValue')
    is_expected.to contain_ironic_config('DEFAULT/bar').with_value('barValue')
    is_expected.to contain_ironic_config('DEFAULT/baz').with_ensure('absent')
  end

end
