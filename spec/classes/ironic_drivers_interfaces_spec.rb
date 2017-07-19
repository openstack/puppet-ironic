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
# Unit tests for ironic::drivers::interfaces class
#

require 'spec_helper'

describe 'ironic::drivers::interfaces' do

  shared_examples_for 'ironic hardware interfaces' do

    context 'with default parameters' do
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_boot_interfaces').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_console_interfaces').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_deploy_interfaces').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_inspect_interfaces').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_management_interfaces').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_network_interfaces').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_power_interfaces').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_raid_interfaces').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_storage_interfaces').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_vendor_interfaces').with_value('<SERVICE DEFAULT>') }
    end

    context 'when overriding parameters' do
      let :params do
        { :enabled_boot_interfaces       => ['pxe'],
          :enabled_console_interfaces    => ['socat', 'shellinabox'],
          :enabled_deploy_interfaces     => ['iscsi'],
          :enabled_inspect_interfaces    => ['inspector'],
          :enabled_management_interfaces => ['ipmitool', 'irmc'],
          :enabled_network_interfaces    => ['flat','neutron'],
          :enabled_power_interfaces      => ['irmc', 'ipmitool'],
          :enabled_raid_interfaces       => ['agent', 'no-raid'],
          :enabled_storage_interfaces    => ['cinder'],
          :enabled_vendor_interfaces     => ['no-vendor'] }
      end

      it { is_expected.to contain_ironic_config('DEFAULT/enabled_boot_interfaces').with_value('pxe') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_console_interfaces').with_value('socat,shellinabox') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_deploy_interfaces').with_value('iscsi') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_inspect_interfaces').with_value('inspector') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_management_interfaces').with_value('ipmitool,irmc') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_network_interfaces').with_value('flat,neutron') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_power_interfaces').with_value('irmc,ipmitool') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_raid_interfaces').with_value('agent,no-raid') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_storage_interfaces').with_value('cinder') }
      it { is_expected.to contain_ironic_config('DEFAULT/enabled_vendor_interfaces').with_value('no-vendor') }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end
      it_configures 'ironic hardware interfaces'
    end
  end

end
