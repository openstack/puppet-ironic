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
# Unit tests for ironic::drivers::inspector
#

require 'spec_helper'

describe 'ironic::drivers::inspector' do

  shared_examples_for 'ironic::drivers::inspector' do
    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('inspector/power_off').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('inspector/extra_kernel_params').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('inspector/require_managed_boot').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('inspector/add_ports').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('inspector/keep_ports').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('inspector/hooks').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('inspector/physical_network_cidr_map').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      let :params do
        {
          :power_off                 => false,
          :extra_kernel_params       => 'ipa-inspection-collectors=a,b,c',
          :require_managed_boot      => true,
          :add_ports                 => 'all',
          :keep_ports                => 'all',
          :additional_hooks          => 'hook1,hook2',
          :physical_network_cidr_map => {
            '192.168.20.0/24' => 'physnet_a',
            '2001:db8::/64'   => 'physnet_b'
          },
        }
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('inspector/power_off').with_value(params[:power_off])
        is_expected.to contain_ironic_config('inspector/extra_kernel_params').with_value(params[:extra_kernel_params])
        is_expected.to contain_ironic_config('inspector/require_managed_boot').with_value(true)
        is_expected.to contain_ironic_config('inspector/add_ports').with_value('all')
        is_expected.to contain_ironic_config('inspector/keep_ports').with_value('all')
        is_expected.to contain_ironic_config('inspector/hooks').with_value('$default_hooks,hook1,hook2')
        is_expected.to contain_ironic_config('inspector/physical_network_cidr_map').with_value('192.168.20.0/24:physnet_a,2001:db8::/64:physnet_b')
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

      it_behaves_like 'ironic::drivers::inspector'
    end
  end

end
