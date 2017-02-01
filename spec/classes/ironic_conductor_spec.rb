#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
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
# Unit tests for ironic::conductor class
#

require 'spec_helper'

describe 'ironic::conductor' do

  let :default_params do
    { :package_ensure                => 'present',
      :enabled                       => true,
      :enabled_drivers               => ['pxe_ipmitool'],
      :enabled_hardware_types        => ['ipmi'],
      :max_time_interval             => '120',
      :force_power_state_during_sync => true }
  end

  let :params do
    {}
  end

  shared_examples_for 'ironic conductor' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('ironic::params') }
    it { is_expected.to contain_class('ironic::drivers::agent') }

    it 'installs ironic conductor package' do
      if platform_params.has_key?(:conductor_package)
        is_expected.to contain_package('ironic-conductor').with(
          :name   => platform_params[:conductor_package],
          :ensure => p[:package_ensure],
          :tag    => ['openstack', 'ironic-package'],
        )
        is_expected.to contain_package('ironic-conductor').that_requires('Anchor[ironic::install::begin]')
        is_expected.to contain_package('ironic-conductor').that_notifies('Anchor[ironic::install::end]')
      end
    end

    it 'ensure ironic conductor service is running' do
      is_expected.to contain_service('ironic-conductor').with(
        'hasstatus' => true,
        'tag'       => 'ironic-service',
      )
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('DEFAULT/enabled_drivers').with_value('pxe_ipmitool')
      is_expected.to contain_ironic_config('DEFAULT/enabled_hardware_types').with_value('ipmi')
      is_expected.to contain_ironic_config('conductor/max_time_interval').with_value(p[:max_time_interval])
      is_expected.to contain_ironic_config('conductor/force_power_state_during_sync').with_value(p[:force_power_state_during_sync])
      is_expected.to contain_ironic_config('conductor/automated_clean').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/api_url').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/cleaning_network').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/provisioning_network').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/continue_if_disk_secure_erase_fails').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/http_url').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/http_root').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/configdrive_use_swift').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/configdrive_swift_container').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/default_boot_option').with(:value => '<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :enabled_drivers               => ['pxe_ssh', 'agent_ssh'],
          :enabled_hardware_types        => ['ipmi', 'irmc'],
          :max_time_interval             => '50',
          :force_power_state_during_sync => false,
          :automated_clean               => false,
          :cleaning_network              => '00000000-0000-0000-0000-000000000000',
          :api_url                       => 'https://127.0.0.1:6385',
          :provisioning_network          => '00000000-0000-0000-0000-000000000000',
          :cleaning_disk_erase           => 'metadata',
          :http_url                      => 'http://host:port',
          :http_root                     => '/src/www',
          :configdrive_use_swift         => true,
          :configdrive_swift_container   => 'cont',
          :default_boot_option           => 'local',
        )
      end
      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('DEFAULT/enabled_drivers').with_value('pxe_ssh,agent_ssh')
        is_expected.to contain_ironic_config('DEFAULT/enabled_hardware_types').with_value('ipmi,irmc')
        is_expected.to contain_ironic_config('conductor/max_time_interval').with_value(p[:max_time_interval])
        is_expected.to contain_ironic_config('conductor/force_power_state_during_sync').with_value(p[:force_power_state_during_sync])
        is_expected.to contain_ironic_config('conductor/automated_clean').with_value(p[:automated_clean])
        is_expected.to contain_ironic_config('conductor/api_url').with_value(p[:api_url])
        is_expected.to contain_ironic_config('neutron/cleaning_network').with_value('00000000-0000-0000-0000-000000000000')
        is_expected.to contain_ironic_config('neutron/provisioning_network').with_value('00000000-0000-0000-0000-000000000000')
        is_expected.to contain_ironic_config('deploy/erase_devices_priority').with_value(0)
        is_expected.to contain_ironic_config('deploy/erase_devices_metadata_priority').with_value(10)
        is_expected.to contain_ironic_config('deploy/http_url').with_value(p[:http_url])
        is_expected.to contain_ironic_config('deploy/http_root').with_value(p[:http_root])
        is_expected.to contain_ironic_config('conductor/configdrive_use_swift').with_value(p[:configdrive_use_swift])
        is_expected.to contain_ironic_config('conductor/configdrive_swift_container').with_value(p[:configdrive_swift_container])
        is_expected.to contain_ironic_config('deploy/default_boot_option').with_value(p[:default_boot_option])
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

        case facts[:osfamily]
        when 'Debian'
          let :platform_params do
            { :conductor_package => 'ironic-conductor',
              :conductor_service => 'ironic-conductor' }
          end
          # https://bugs.launchpad.net/cloud-archive/+bug/1572800
          it 'installs ipmitool package' do
            is_expected.to contain_package('ipmitool').with(
              :ensure => 'present',
              :name   => 'ipmitool',
              :tag    => ['openstack', 'ironic-package'],
            )
          end
        when 'RedHat'
          let :platform_params do
            { :conductor_service => 'ironic-conductor' }
          end
        end

      it_behaves_like 'ironic conductor'
    end
  end

end
