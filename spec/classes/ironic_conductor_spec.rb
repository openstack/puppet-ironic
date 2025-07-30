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
      :force_power_state_during_sync => true }
  end

  let :params do
    {}
  end

  shared_examples_for 'ironic conductor' do
    let :pre_condition do
      "class { 'ironic::glance':
         password => 'password',
       }"
    end

    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('ironic::params') }
    it { is_expected.to contain_class('ironic::drivers::agent') }

    it 'installs ironic conductor package' do
      is_expected.to contain_package('ironic-conductor').with(
        :name   => platform_params[:conductor_package],
        :ensure => p[:package_ensure],
        :tag    => ['openstack', 'ironic-package'],
      )
    end

    it 'ensure ironic conductor service is running' do
      is_expected.to contain_service('ironic-conductor').with(
        :ensure    => 'running',
        :name      => platform_params[:conductor_service],
        :enable    => true,
        :hasstatus => true,
        :tag       => 'ironic-service',
      )
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('DEFAULT/enabled_hardware_types').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/force_power_state_during_sync').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/automated_clean').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/cleaning_network').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/provisioning_network').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/rescuing_network').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/inspection_network').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/continue_if_disk_secure_erase_fails').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/http_url').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/http_root').with(:value => '/httpboot')
      is_expected.to contain_ironic_config('DEFAULT/force_raw_images').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/configdrive_use_object_store').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/configdrive_swift_container').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/inspect_wait_timeout').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/default_boot_option').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('deploy/default_boot_mode').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/port_setup_delay').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/soft_power_off_timeout').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/power_state_change_timeout').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/sync_power_state_interval').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/sync_power_state_workers').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/power_state_sync_max_retries').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/power_failure_recovery_interval').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/periodic_max_workers').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/graceful_shutdown_timeout').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/conductor_group').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/deploy_kernel').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/deploy_ramdisk').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/deploy_kernel_by_arch').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/deploy_ramdisk_by_arch').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/rescue_kernel').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/rescue_ramdisk').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/rescue_kernel_by_arch').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/rescue_ramdisk_by_arch').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/bootloader').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/bootloader_by_arch').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('DEFAULT/image_download_concurrency').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/deploy_callback_timeout').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/heartbeat_interval').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/heartbeat_timeout').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/max_concurrent_deploy').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('conductor/max_concurrent_clean').with(:value => '<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :enabled_hardware_types            => ['ipmi', 'irmc'],
          :force_power_state_during_sync     => false,
          :automated_clean                   => false,
          :cleaning_network                  => '00000000-0000-0000-0000-000000000000',
          :provisioning_network              => '00000000-0000-0000-0000-000000000000',
          :rescuing_network                  => '00000000-0000-0000-0000-000000000000',
          :inspection_network                => '00000000-0000-0000-0000-000000000000',
          :cleaning_disk_erase               => 'metadata',
          :http_url                          => 'http://host:port',
          :http_root                         => '/src/www',
          :force_raw_images                  => false,
          :configdrive_use_object_store      => true,
          :configdrive_swift_container       => 'cont',
          :inspect_wait_timeout              => 600,
          :default_boot_option               => 'local',
          :default_boot_mode                 => 'uefi',
          :port_setup_delay                  => '15',
          :soft_power_off_timeout            => 600,
          :power_state_change_timeout        => '300',
          :sync_power_state_interval         => 120,
          :sync_power_state_workers          => 2,
          :power_state_sync_max_retries      => 5,
          :power_failure_recovery_interval   => 120,
          :periodic_max_workers              => 4,
          :graceful_shutdown_timeout         => 60,
          :conductor_group                   => 'in-the-closet-to-the-left',
          :deploy_kernel                     => 'http://host/deploy.kernel',
          :deploy_ramdisk                    => 'http://host/deploy.ramdisk',
          :deploy_kernel_by_arch             => {'x86_64' => 'http://host/deploy.kernel'},
          :deploy_ramdisk_by_arch            => {'x86_64' => 'http://host/deploy.ramdisk'},
          :rescue_kernel                     => 'http://host/rescue.kernel',
          :rescue_ramdisk                    => 'http://host/rescue.ramdisk',
          :rescue_kernel_by_arch             => {'x86_64' => 'http://host/rescue.kernel'},
          :rescue_ramdisk_by_arch            => {'x86_64' => 'http://host/rescue.ramdisk'},
          :bootloader                        => 'http://host/bootloader',
          :bootloader_by_arch                => {'x86_64' => 'http://host/bootloader'},
          :allow_provisioning_in_maintenance => false,
          :image_download_concurrency        => 20,
          :deploy_callback_timeout           => 1800,
          :heartbeat_interval                => 10,
          :heartbeat_timeout                 => 60,
          :max_concurrent_deploy             => 250,
          :max_concurrent_clean              => 50,
        )
      end
      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('DEFAULT/enabled_hardware_types').with_value('ipmi,irmc')
        is_expected.to contain_ironic_config('conductor/force_power_state_during_sync').with_value(p[:force_power_state_during_sync])
        is_expected.to contain_ironic_config('conductor/automated_clean').with_value(p[:automated_clean])
        is_expected.to contain_ironic_config('neutron/cleaning_network').with_value('00000000-0000-0000-0000-000000000000')
        is_expected.to contain_ironic_config('neutron/provisioning_network').with_value('00000000-0000-0000-0000-000000000000')
        is_expected.to contain_ironic_config('neutron/rescuing_network').with_value('00000000-0000-0000-0000-000000000000')
        is_expected.to contain_ironic_config('neutron/inspection_network').with_value('00000000-0000-0000-0000-000000000000')
        is_expected.to contain_ironic_config('deploy/erase_devices_priority').with_value(0)
        is_expected.to contain_ironic_config('deploy/erase_devices_metadata_priority').with_value(10)
        is_expected.to contain_ironic_config('deploy/http_url').with_value(p[:http_url])
        is_expected.to contain_ironic_config('deploy/http_root').with_value(p[:http_root])
        is_expected.to contain_ironic_config('DEFAULT/force_raw_images').with_value(p[:force_raw_images])
        is_expected.to contain_ironic_config('deploy/configdrive_use_object_store').with_value(p[:configdrive_use_object_store])
        is_expected.to contain_ironic_config('conductor/configdrive_swift_container').with_value(p[:configdrive_swift_container])
        is_expected.to contain_ironic_config('conductor/inspect_wait_timeout').with_value(p[:inspect_wait_timeout])
        is_expected.to contain_ironic_config('deploy/default_boot_option').with_value(p[:default_boot_option])
        is_expected.to contain_ironic_config('deploy/default_boot_mode').with_value(p[:default_boot_mode])
        is_expected.to contain_ironic_config('neutron/port_setup_delay').with_value(p[:port_setup_delay])
        is_expected.to contain_ironic_config('conductor/soft_power_off_timeout').with_value(p[:soft_power_off_timeout])
        is_expected.to contain_ironic_config('conductor/power_state_change_timeout').with_value(p[:power_state_change_timeout])
        is_expected.to contain_ironic_config('conductor/sync_power_state_interval').with_value(p[:sync_power_state_interval])
        is_expected.to contain_ironic_config('conductor/sync_power_state_workers').with_value(p[:sync_power_state_workers])
        is_expected.to contain_ironic_config('conductor/power_state_sync_max_retries').with_value(p[:power_state_sync_max_retries])
        is_expected.to contain_ironic_config('conductor/power_failure_recovery_interval').with_value(p[:power_failure_recovery_interval])
        is_expected.to contain_ironic_config('conductor/periodic_max_workers').with_value(p[:periodic_max_workers])
        is_expected.to contain_ironic_config('conductor/graceful_shutdown_timeout').with_value(p[:graceful_shutdown_timeout])
        is_expected.to contain_ironic_config('conductor/conductor_group').with_value(p[:conductor_group])
        is_expected.to contain_ironic_config('conductor/deploy_kernel').with_value(p[:deploy_kernel])
        is_expected.to contain_ironic_config('conductor/deploy_ramdisk').with_value(p[:deploy_ramdisk])
        is_expected.to contain_ironic_config('conductor/deploy_kernel_by_arch').with_value('x86_64:http://host/deploy.kernel')
        is_expected.to contain_ironic_config('conductor/deploy_ramdisk_by_arch').with_value('x86_64:http://host/deploy.ramdisk')
        is_expected.to contain_ironic_config('conductor/rescue_kernel').with_value(p[:rescue_kernel])
        is_expected.to contain_ironic_config('conductor/rescue_ramdisk').with_value(p[:rescue_ramdisk])
        is_expected.to contain_ironic_config('conductor/rescue_kernel_by_arch').with_value('x86_64:http://host/rescue.kernel')
        is_expected.to contain_ironic_config('conductor/rescue_ramdisk_by_arch').with_value('x86_64:http://host/rescue.ramdisk')
        is_expected.to contain_ironic_config('conductor/bootloader').with_value(p[:bootloader])
        is_expected.to contain_ironic_config('conductor/bootloader_by_arch').with_value('x86_64:http://host/bootloader')
        is_expected.to contain_ironic_config('conductor/allow_provisioning_in_maintenance').with_value(p[:allow_provisioning_in_maintenance])
        is_expected.to contain_ironic_config('DEFAULT/image_download_concurrency').with_value(p[:image_download_concurrency])
        is_expected.to contain_ironic_config('conductor/deploy_callback_timeout').with_value(p[:deploy_callback_timeout])
        is_expected.to contain_ironic_config('conductor/heartbeat_interval').with_value(p[:heartbeat_interval])
        is_expected.to contain_ironic_config('conductor/heartbeat_timeout').with_value(p[:heartbeat_timeout])
        is_expected.to contain_ironic_config('conductor/max_concurrent_deploy').with_value(p[:max_concurrent_deploy])
        is_expected.to contain_ironic_config('conductor/max_concurrent_clean').with_value(p[:max_concurrent_clean])
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

        case facts[:os]['family']
        when 'Debian'
          let :platform_params do
            { :conductor_package => 'ironic-conductor',
              :conductor_service => 'ironic-conductor' }
          end
        when 'RedHat'
          let :platform_params do
            { :conductor_package => 'openstack-ironic-conductor',
              :conductor_service => 'openstack-ironic-conductor' }
          end
        end

      it_behaves_like 'ironic conductor'
    end
  end

end
