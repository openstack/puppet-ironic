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
      it 'configures the defaults' do
        is_expected.to contain_ironic_config('DEFAULT/default_bios_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_boot_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_console_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_deploy_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_inspect_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_management_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_network_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_power_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_raid_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_rescue_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_storage_interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_vendor_interface').with_value('<SERVICE DEFAULT>')

        is_expected.to contain_ironic_config('DEFAULT/enabled_bios_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_boot_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_console_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_deploy_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_inspect_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_management_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_network_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_power_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_raid_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_rescue_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_storage_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/enabled_vendor_interfaces').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding parameters' do
      let :params do
        {
          :default_bios_interface        => 'no-bios',
          :default_boot_interface        => 'pxe',
          :default_console_interface     => 'socat',
          :default_deploy_interface      => 'iscsi',
          :default_inspect_interface     => 'inspector',
          :default_management_interface  => 'ipmitool',
          :default_network_interface     => 'flat',
          :default_power_interface       => 'ipmitool',
          :default_raid_interface        => 'no-raid',
          :default_rescue_interface      => 'no-rescue',
          :default_storage_interface     => 'cinder',
          :default_vendor_interface      => 'no-vendor',

          :enabled_bios_interfaces       => ['no-bios'],
          :enabled_boot_interfaces       => ['pxe'],
          :enabled_console_interfaces    => ['socat', 'shellinabox'],
          :enabled_deploy_interfaces     => ['iscsi'],
          :enabled_inspect_interfaces    => ['inspector'],
          :enabled_management_interfaces => ['ipmitool', 'irmc'],
          :enabled_network_interfaces    => ['flat','neutron'],
          :enabled_power_interfaces      => ['irmc', 'ipmitool'],
          :enabled_raid_interfaces       => ['agent', 'no-raid'],
          :enabled_rescue_interfaces     => ['agent', 'no-rescue'],
          :enabled_storage_interfaces    => ['cinder'],
          :enabled_vendor_interfaces     => ['no-vendor']
        }
      end

      it 'configures the given values' do
        is_expected.to contain_ironic_config('DEFAULT/default_bios_interface').with_value('no-bios')
        is_expected.to contain_ironic_config('DEFAULT/default_boot_interface').with_value('pxe')
        is_expected.to contain_ironic_config('DEFAULT/default_console_interface').with_value('socat')
        is_expected.to contain_ironic_config('DEFAULT/default_deploy_interface').with_value('iscsi')
        is_expected.to contain_ironic_config('DEFAULT/default_inspect_interface').with_value('inspector')
        is_expected.to contain_ironic_config('DEFAULT/default_management_interface').with_value('ipmitool')
        is_expected.to contain_ironic_config('DEFAULT/default_network_interface').with_value('flat')
        is_expected.to contain_ironic_config('DEFAULT/default_power_interface').with_value('ipmitool')
        is_expected.to contain_ironic_config('DEFAULT/default_raid_interface').with_value('no-raid')
        is_expected.to contain_ironic_config('DEFAULT/default_rescue_interface').with_value('no-rescue')
        is_expected.to contain_ironic_config('DEFAULT/default_storage_interface').with_value('cinder')
        is_expected.to contain_ironic_config('DEFAULT/default_vendor_interface').with_value('no-vendor')

        is_expected.to contain_ironic_config('DEFAULT/enabled_bios_interfaces').with_value('no-bios')
        is_expected.to contain_ironic_config('DEFAULT/enabled_boot_interfaces').with_value('pxe')
        is_expected.to contain_ironic_config('DEFAULT/enabled_console_interfaces').with_value('socat,shellinabox')
        is_expected.to contain_ironic_config('DEFAULT/enabled_deploy_interfaces').with_value('iscsi')
        is_expected.to contain_ironic_config('DEFAULT/enabled_inspect_interfaces').with_value('inspector')
        is_expected.to contain_ironic_config('DEFAULT/enabled_management_interfaces').with_value('ipmitool,irmc')
        is_expected.to contain_ironic_config('DEFAULT/enabled_network_interfaces').with_value('flat,neutron')
        is_expected.to contain_ironic_config('DEFAULT/enabled_power_interfaces').with_value('irmc,ipmitool')
        is_expected.to contain_ironic_config('DEFAULT/enabled_raid_interfaces').with_value('agent,no-raid')
        is_expected.to contain_ironic_config('DEFAULT/enabled_rescue_interfaces').with_value('agent,no-rescue')
        is_expected.to contain_ironic_config('DEFAULT/enabled_storage_interfaces').with_value('cinder')
        is_expected.to contain_ironic_config('DEFAULT/enabled_vendor_interfaces').with_value('no-vendor')
      end
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
