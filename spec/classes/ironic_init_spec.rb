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
# Unit tests for ironic
#

require 'spec_helper'

describe 'ironic' do

  shared_examples_for 'ironic' do

    let :pre_condition do
      "class { 'ironic::glance':
         password => 'password',
       }
       class { 'ironic::neutron':
         password => 'password',
       }"
    end

    context 'with defaults' do
      it { is_expected.to contain_class('ironic::params') }

      it { is_expected.to contain_class('ironic::glance') }
      it { is_expected.to contain_class('ironic::neutron') }

      it 'installs ironic-common package' do
        is_expected.to contain_package('ironic-common').with(
          :ensure => 'present',
          :name   => platform_params[:common_package_name],
          :tag    => ['openstack', 'ironic-package'],
        )
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('ironic_config').with({
          :purge => false
        })
      end

      it 'configures ironic.conf' do
        is_expected.to contain_ironic_config('DEFAULT/auth_strategy').with_value('keystone')
        is_expected.to contain_ironic_config('DEFAULT/host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/my_ip').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/my_ipv6').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/default_resource_class').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/notification_level').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/versioned_notifications_topics').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/rpc_transport').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/rbac_service_role_elevated_access').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('DEFAULT/rbac_service_project_name').with_value('services')

        is_expected.to contain_oslo__messaging__default('ironic_config').with(
          :executor_thread_pool_size => '<SERVICE DEFAULT>',
          :transport_url             => '<SERVICE DEFAULT>',
          :rpc_response_timeout      => '<SERVICE DEFAULT>',
          :control_exchange          => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_oslo__messaging__rabbit('ironic_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
          :heartbeat_rate                  => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread            => nil,
          :rabbit_qos_prefetch_count       => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :kombu_compression               => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('ironic_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>',
          :retry         => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with parameters' do
      let :params do
        {
          :host                               => 'host.example.com',
          :my_ip                              => '127.0.0.1',
          :my_ipv6                            => '::1',
          :default_resource_class             => 'myclass',
          :notification_level                 => 'warning',
          :versioned_notifications_topics     => 'ironic_versioned_notifications',
          :rpc_transport                      => 'oslo',
          :executor_thread_pool_size          => '128',
          :default_transport_url              => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout               => '30',
          :control_exchange                   => 'ironic',
          :rabbit_use_ssl                     => true,
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_heartbeat_in_pthread        => true,
          :rabbit_qos_prefetch_count          => 0,
          :kombu_reconnect_delay              => '5.0',
          :amqp_durable_queues                => true,
          :kombu_compression                  => 'gzip',
          :kombu_ssl_ca_certs                 => '/etc/ca.cert',
          :kombu_ssl_certfile                 => '/etc/certfile',
          :kombu_ssl_keyfile                  => '/etc/key',
          :kombu_ssl_version                  => 'TLSv1',
          :rabbit_ha_queues                   => true,
          :rabbit_quorum_queue                => true,
          :rabbit_quorum_delivery_limit       => 3,
          :rabbit_quorum_max_memory_length    => 5,
          :rabbit_quorum_max_memory_bytes     => 1073741824,
          :rabbit_enable_cancel_on_failover   => false,
          :notification_transport_url         => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_driver                => 'messagingv2',
          :notification_topics                => 'openstack',
          :notification_retry                 => 10,
          :rbac_service_role_elevated_access  => true,
          :rbac_service_project_name          => 'service',
        }
      end

      it 'configures ironic.conf' do
        is_expected.to contain_ironic_config('DEFAULT/auth_strategy').with_value('keystone')
        is_expected.to contain_ironic_config('DEFAULT/host').with_value('host.example.com')
        is_expected.to contain_ironic_config('DEFAULT/my_ip').with_value('127.0.0.1')
        is_expected.to contain_ironic_config('DEFAULT/my_ipv6').with_value('::1')
        is_expected.to contain_ironic_config('DEFAULT/default_resource_class').with_value('myclass')
        is_expected.to contain_ironic_config('DEFAULT/notification_level').with_value('warning')
        is_expected.to contain_ironic_config('DEFAULT/versioned_notifications_topics').with_value('ironic_versioned_notifications')
        is_expected.to contain_ironic_config('DEFAULT/rpc_transport').with_value('oslo')
        is_expected.to contain_ironic_config('DEFAULT/rbac_service_role_elevated_access').with_value(true)
        is_expected.to contain_ironic_config('DEFAULT/rbac_service_project_name').with_value('service')

        is_expected.to contain_oslo__messaging__default('ironic_config').with(
          :executor_thread_pool_size => '128',
          :transport_url             => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout      => '30',
          :control_exchange          => 'ironic',
        )
        is_expected.to contain_oslo__messaging__rabbit('ironic_config').with(
          :rabbit_use_ssl                  => true,
          :heartbeat_timeout_threshold     => '60',
          :heartbeat_rate                  => '10',
          :heartbeat_in_pthread            => true,
          :rabbit_qos_prefetch_count       => 0,
          :kombu_reconnect_delay           => '5.0',
          :amqp_durable_queues             => true,
          :kombu_compression               => 'gzip',
          :kombu_ssl_ca_certs              => '/etc/ca.cert',
          :kombu_ssl_certfile              => '/etc/certfile',
          :kombu_ssl_keyfile               => '/etc/key',
          :kombu_ssl_version               => 'TLSv1',
          :rabbit_ha_queues                => true,
          :rabbit_quorum_queue             => true,
          :rabbit_quorum_delivery_limit    => 3,
          :rabbit_quorum_max_memory_length => 5,
          :rabbit_quorum_max_memory_bytes  => 1073741824,
          :enable_cancel_on_failover       => false,
        )
        is_expected.to contain_oslo__messaging__notifications('ironic_config').with(
          :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :driver        => 'messagingv2',
          :topics        => 'openstack',
          :retry         => 10,
        )
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

      let :platform_params do
        case facts[:os]['family']
        when 'Debian'
          { :common_package_name => 'ironic-common' }
        when 'RedHat'
          { :common_package_name => 'openstack-ironic-common' }
        end
      end

      it_behaves_like 'ironic'
    end
  end

end
