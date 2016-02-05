require 'spec_helper'

describe 'ironic::config' do

  let :params do
    { :ironic_config => {
        'DEFAULT/foo' => { 'value'  => 'fooValue' },
        'DEFAULT/bar' => { 'value'  => 'barValue' },
        'DEFAULT/baz' => { 'ensure' => 'absent' }
      },
      :ironic_api_paste_ini => {
        'DEFAULT/foo2' => { 'value'  => 'fooValue' },
        'DEFAULT/bar2' => { 'value'  => 'barValue' },
        'DEFAULT/baz2' => { 'ensure' => 'absent' }
      }
    }
  end

  it 'configures arbitrary ironic configurations' do
    is_expected.to contain_ironic_config('DEFAULT/foo').with_value('fooValue')
    is_expected.to contain_ironic_config('DEFAULT/bar').with_value('barValue')
    is_expected.to contain_ironic_config('DEFAULT/baz').with_ensure('absent')
  end

  it 'configures arbitrary ironic-api-paste configurations' do
    is_expected.to contain_ironic_api_paste_ini('DEFAULT/foo2').with_value('fooValue')
    is_expected.to contain_ironic_api_paste_ini('DEFAULT/bar2').with_value('barValue')
    is_expected.to contain_ironic_api_paste_ini('DEFAULT/baz2').with_ensure('absent')
  end

end
