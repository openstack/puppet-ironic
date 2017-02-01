# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Unit tests for ironic::drivers::hardware_interface
#

require 'spec_helper'

describe 'ironic::drivers::hardware_interface' do

  let :params do
    {}
  end

  let (:title) { 'foo' }

  shared_examples_for 'ironic hardware interface' do
    let :p do
      params
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('DEFAULT/enabled_foo_interfaces').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('DEFAULT/default_foo_interface').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
            :enabled_list => ['one', 'two'],
            :default      => 'two',
        )
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('DEFAULT/enabled_foo_interfaces').with_value('one,two')
        is_expected.to contain_ironic_config('DEFAULT/default_foo_interface').with_value(p[:default])
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

      it_behaves_like 'ironic hardware interface'
    end
  end

end
