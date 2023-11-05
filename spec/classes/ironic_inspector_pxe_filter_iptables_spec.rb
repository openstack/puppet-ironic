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
# Unit tests for ironic::inspector::pxe_filter::iptables class
#

require 'spec_helper'

describe 'ironic::inspector::pxe_filter::iptables' do
  let :pre_condition do
     "class { 'ironic::inspector::authtoken':
        password => 'password',
      }
      class { 'ironic::inspector':
      }"
  end

  shared_examples_for 'ironic::inspector::pxe_filter::iptables' do
    it 'configure iptables pxe filter default params' do
      is_expected.to contain_ironic_inspector_config('iptables/dnsmasq_interface').with_value('br-ctlplane')
      is_expected.to contain_ironic_inspector_config('iptables/firewall_chain').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('iptables/ethoib_interfaces').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('iptables/ip_version').with_value('<SERVICE DEFAULT>')
    end

    context 'with specific parameters' do
      let :params do
        {
          :firewall_chain    => 'ironic-inspector',
          :ethoib_interfaces => ['interface0', 'interface1'],
          :ip_version        => 4,
        }
      end

      it 'configure iptables pxe filter specific params' do
        is_expected.to contain_ironic_inspector_config('iptables/dnsmasq_interface').with_value('br-ctlplane')
        is_expected.to contain_ironic_inspector_config('iptables/firewall_chain').with_value('ironic-inspector')
        is_expected.to contain_ironic_inspector_config('iptables/ethoib_interfaces').with_value('interface0,interface1')
        is_expected.to contain_ironic_inspector_config('iptables/ip_version').with_value(4)
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

      it_behaves_like 'ironic::inspector::pxe_filter::iptables'
    end
  end

end
