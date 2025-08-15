#
# Copyright (C) 2015 Red Hat, Inc
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
# Unit tests for ironic::inspector class
#

require 'spec_helper'

describe 'ironic::inspector' do
  let :pre_condition do
     "class { 'ironic::inspector::authtoken':
        password => 'password',
      }"
  end

  let :params do
    {
      :pxe_transfer_protocol => 'tftp',
      :auth_strategy         => 'keystone',
      :dnsmasq_interface     => 'br-ctlplane',
      :ramdisk_logs_dir      => '/var/log/ironic-inspector/ramdisk/',
      :store_data            => 'none',
      :dnsmasq_ip_subnets    => [{ 'ip_range' =>
                                      '192.168.0.100,192.168.0.120',
                                   'mtu' => '1350'},
                                 { 'tag'      => 'subnet1',
                                   'ip_range' => '192.168.1.100,192.168.1.200',
                                   'netmask'  => '255.255.255.0',
                                   'gateway'  => '192.168.1.254',
                                   'mtu'      => '1350'},
                                 { 'tag'                     => 'subnet2',
                                   'ip_range'                => '192.168.2.100,192.168.2.200',
                                   'netmask'                 => '255.255.255.0',
                                   'gateway'                 => '192.168.2.254',
                                   'classless_static_routes' => [{'destination' => '1.2.3.0/24',
                                                                  'nexthop'     => '192.168.2.1'},
                                                                 {'destination' => '4.5.6.0/24',
                                                                  'nexthop'     => '192.168.2.1'}]},
                                 { 'tag'      => 'subnet3',
                                   'ip_range' => '2001:4888:a03:313a:c0:fe0:0:c200,2001:4888:a03:313a:c0:fe0:0:c2ff',
                                   'netmask'  => 'ffff:ffff:ffff:ffff::',
                                   'gateway'  => '2001:4888:a03:313a:c0:fe0:0:c000' }],
      :dnsmasq_local_ip      => '192.168.0.1',
      :ipxe_timeout          => 0,
      :http_port             => 8088,
      :tftp_root             => '/tftpboot',
      :http_root             => '/httpboot',
    }
  end


  shared_examples_for 'ironic inspector' do

    let :p do
      params
    end

    it { is_expected.to contain_class('ironic::params') }

    it 'installs ironic inspector package' do
      is_expected.to contain_package('ironic-inspector').with(
        :ensure => 'present',
        :name   => platform_params[:inspector_package],
        :tag    => ['openstack', 'ironic-inspector-package'],
      )

      if platform_params.has_key?(:inspector_dnsmasq_package)
        is_expected.to contain_package('ironic-inspector-dnsmasq').with(
          :ensure => 'present',
          :name   => platform_params[:inspector_dnsmasq_package],
          :tag    => ['openstack', 'ironic-inspector-package'],
        )
      end
    end

    it 'ensure ironic inspector service is running' do
      is_expected.to contain_service('ironic-inspector').with(
        :ensure    => 'running',
        :name      => platform_params[:inspector_service],
        :enable    => true,
        :hasstatus => true,
        :tag       => 'ironic-inspector-service',
      )
    end

    it 'ensure ironic inspector dnsmasq service is running' do
      if platform_params.has_key?(:inspector_dnsmasq_service)
        is_expected.to contain_service('ironic-inspector-dnsmasq').with(
          :ensure    => 'running',
          :name      => platform_params[:inspector_dnsmasq_service],
          :enable    => true,
          :hasstatus => true,
          :tag       => 'ironic-inspector-dnsmasq-service',
        )
      end
    end

    it 'configures inspector.conf' do
      is_expected.to contain_ironic_inspector_config('DEFAULT/listen_address').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('DEFAULT/auth_strategy').with_value(p[:auth_strategy])
      is_expected.to contain_ironic_inspector_config('DEFAULT/timeout').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('DEFAULT/api_max_limit').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('capabilities/boot_mode').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('processing/ramdisk_logs_dir').with_value(p[:ramdisk_logs_dir])
      is_expected.to contain_ironic_inspector_config('processing/always_store_ramdisk_logs').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('processing/add_ports').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('processing/keep_ports').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('processing/store_data').with_value(p[:store_data])
      is_expected.to contain_ironic_inspector_config('processing/processing_hooks').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('processing/node_not_found_hook').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('discovery/enroll_node_driver').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('port_physnet/cidr_map').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('DEFAULT/standalone').with_value(true)

      is_expected.to contain_oslo__messaging__default('ironic_inspector_config').with(
        :executor_thread_pool_size => '<SERVICE DEFAULT>',
        :transport_url             => 'fake://',
        :rpc_response_timeout      => '<SERVICE DEFAULT>',
        :control_exchange          => '<SERVICE DEFAULT>'
      )

      is_expected.to contain_oslo__messaging__rabbit('ironic_inspector_config').with(
        :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
        :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
        :heartbeat_rate                  => '<SERVICE DEFAULT>',
        :heartbeat_in_pthread            => nil,
        :rabbit_qos_prefetch_count       => '<SERVICE DEFAULT>',
        :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
        :kombu_failover_strategy         => '<SERVICE DEFAULT>',
        :amqp_durable_queues             => '<SERVICE DEFAULT>',
        :amqp_auto_delete                => '<SERVICE DEFAULT>',
        :kombu_compression               => '<SERVICE DEFAULT>',
        :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
        :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
        :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
        :kombu_ssl_version               => '<SERVICE DEFAULT>',
        :rabbit_ha_queues                => '<SERVICE DEFAULT>',
        :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
        :rabbit_transient_queues_ttl     => '<SERVICE DEFAULT>',
        :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
        :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
        :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
        :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
      )
    end

    it 'should not contain dhcp hostsdir' do
      is_expected.not_to contain_file('ironic-inspector-dnsmasq-dhcp-hostsdir')
    end

    it 'should contain file /etc/ironic-inspector/dnsmasq.conf' do
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with(
        'ensure'  => 'file',
        'content' => /pxelinux/,
        'tag'     => 'ironic-inspector-dnsmasq-file',
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-range=192.168.0.100,192.168.0.120,10m$/
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-option-force=option:mtu,1350$/
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-range=set:subnet1,192.168.1.100,192.168.1.200,255.255.255.0,10m$/
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-option=tag:subnet1,option:router,192.168.1.254$/
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-option-force=tag:subnet1,option:mtu,1350$/
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-range=set:subnet2,192.168.2.100,192.168.2.200,255.255.255.0,10m$/
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-option=tag:subnet2,option:router,192.168.2.254$/
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-option=tag:subnet2,option:classless-static-route,1.2.3.0\/24,192.168.2.1,4.5.6.0\/24,192.168.2.1$/
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-range=set:subnet3,2001:4888:a03:313a:c0:fe0:0:c200,2001:4888:a03:313a:c0:fe0:0:c2ff,64,10m$/
      )
      is_expected.not_to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-option=tag:subnet3,option:router,2001:4888:a03:313a:c0:fe0:0:c000$/
      )
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-sequential-ip$/
      )
      is_expected.not_to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^log-facility=.*$/
      )
      is_expected.not_to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /^dhcp-hostsdir=.*$/
      )
    end
    it 'should contain file /tftpboot/pxelinux.cfg/default' do
      is_expected.to contain_file('/tftpboot/pxelinux.cfg/default').with(
        'ensure'  => 'file',
        'owner'   => 'ironic-inspector',
        'group'   => 'ironic-inspector',
        'seltype' => 'tftpdir_t',
        'content' => /default/,
        'tag'     => 'ironic-inspector-dnsmasq-file',
      )
      is_expected.to contain_file('/tftpboot/pxelinux.cfg/default').with_content(
        /^append initrd=agent.ramdisk ipa-inspection-callback-url=http:\/\/192.168.0.1:5050\/v1\/continue /
      )
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :dhcp_debug                         => true,
          :listen_address                     => '127.0.0.1',
          :api_max_limit                      => 100,
          :pxe_transfer_protocol              => 'http',
          :additional_processing_hooks        => 'hook1,hook2',
          :ramdisk_collectors                 => 'default',
          :ramdisk_kernel_args                => 'foo=bar',
          :http_port                          => 3816,
          :tftp_root                          => '/var/lib/tftpboot',
          :http_root                          => '/var/www/httpboot',
          :detect_boot_mode                   => true,
          :node_not_found_hook                => 'enroll',
          :discovery_default_driver           => 'pxe_ipmitool',
          :dnsmasq_ip_subnets                 => [{'ip_range' => '192.168.0.100,192.168.0.120'}],
          :dnsmasq_dhcp_sequential_ip         => false,
          :dnsmasq_dhcp_hostsdir              => '/etc/ironic-inspector/dhcp-hostsdir',
          :dnsmasq_log_facility               => '/var/log/ironic-inspector/dnsmasq.log',
          :add_ports                          => 'all',
          :keep_ports                         => 'all',
          :always_store_ramdisk_logs          => true,
          :port_physnet_cidr_map              => {'192.168.20.0/24' => 'physnet_a',
                                                  '2001:db8::/64' => 'physnet_b'},
          :uefi_ipxe_bootfile_name            => 'otherpxe.efi',
          :executor_thread_pool_size          => '128',
          :default_transport_url              => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout               => '30',
          :control_exchange                   => 'inspector',
          :rabbit_use_ssl                     => true,
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_heartbeat_in_pthread        => true,
          :rabbit_qos_prefetch_count          => 0,
          :kombu_reconnect_delay              => '5.0',
          :amqp_durable_queues                => true,
          :amqp_auto_delete                   => true,
          :kombu_compression                  => 'gzip',
          :kombu_ssl_ca_certs                 => '/etc/ca.cert',
          :kombu_ssl_certfile                 => '/etc/certfile',
          :kombu_ssl_keyfile                  => '/etc/key',
          :kombu_ssl_version                  => 'TLSv1',
          :rabbit_ha_queues                   => true,
          :rabbit_quorum_queue                => true,
          :rabbit_transient_queues_ttl        => 60,
          :rabbit_quorum_delivery_limit       => 3,
          :rabbit_quorum_max_memory_length    => 5,
          :rabbit_quorum_max_memory_bytes     => 1073741824,
          :rabbit_enable_cancel_on_failover   => false,
        )
      end
      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_inspector_config('DEFAULT/listen_address').with_value(p[:listen_address])
        is_expected.to contain_ironic_inspector_config('DEFAULT/api_max_limit').with_value(100)
        is_expected.to contain_ironic_inspector_config('capabilities/boot_mode').with_value(p[:detect_boot_mode])
        is_expected.to contain_ironic_inspector_config('processing/processing_hooks').with_value('$default_processing_hooks,hook1,hook2')
        is_expected.to contain_ironic_inspector_config('processing/node_not_found_hook').with_value('enroll')
        is_expected.to contain_ironic_inspector_config('processing/add_ports').with_value('all')
        is_expected.to contain_ironic_inspector_config('processing/keep_ports').with_value('all')
        is_expected.to contain_ironic_inspector_config('discovery/enroll_node_driver').with_value('pxe_ipmitool')
        is_expected.to contain_ironic_inspector_config('processing/always_store_ramdisk_logs').with_value(true)
        is_expected.to contain_ironic_inspector_config('port_physnet/cidr_map').with_value('192.168.20.0/24:physnet_a,2001:db8::/64:physnet_b')
        is_expected.to contain_oslo__messaging__default('ironic_inspector_config').with(
          :executor_thread_pool_size => '128',
          :transport_url             => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout      => '30',
          :control_exchange          => 'inspector',
        )
        is_expected.to contain_oslo__messaging__rabbit('ironic_inspector_config').with(
          :rabbit_use_ssl                  => true,
          :heartbeat_timeout_threshold     => '60',
          :heartbeat_rate                  => '10',
          :heartbeat_in_pthread            => true,
          :rabbit_qos_prefetch_count       => 0,
          :kombu_reconnect_delay           => '5.0',
          :amqp_durable_queues             => true,
          :amqp_auto_delete                => true,
          :kombu_compression               => 'gzip',
          :kombu_ssl_ca_certs              => '/etc/ca.cert',
          :kombu_ssl_certfile              => '/etc/certfile',
          :kombu_ssl_keyfile               => '/etc/key',
          :kombu_ssl_version               => 'TLSv1',
          :rabbit_ha_queues                => true,
          :rabbit_quorum_queue             => true,
          :rabbit_transient_queues_ttl     => 60,
          :rabbit_quorum_delivery_limit    => 3,
          :rabbit_quorum_max_memory_length => 5,
          :rabbit_quorum_max_memory_bytes  => 1073741824,
          :enable_cancel_on_failover       => false,
        )
      end

    it 'should contain dhcp hostsdir' do
      is_expected.to contain_file('ironic-inspector-dnsmasq-dhcp-hostsdir').with(
        :ensure => 'directory',
        :path   => '/etc/ironic-inspector/dhcp-hostsdir',
        :owner  => 'ironic-inspector',
        :group  => 'ironic-inspector',
      )
    end

      it 'should contain file /etc/ironic-inspector/dnsmasq.conf' do
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with(
          'ensure'  => 'file',
          'content' => /ipxe/,
          'tag'     => 'ironic-inspector-dnsmasq-file',
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-boot=tag:ipxe,http:\/\/192.168.0.1:3816\/inspector.ipxe$/
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-range=192.168.0.100,192.168.0.120,10m$/
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^log-dhcp$/
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^log-queries$/
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-userclass=set:ipxe6,iPXE$/
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-option=tag:ipxe6,option6:bootfile-url,http:\/\/.*:3816\/inspector.ipxe$/
        )
        is_expected.not_to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-sequential-ip$/
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^log-facility=\/var\/log\/ironic-inspector\/dnsmasq.log$/
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-boot=tag:efi,tag:!ipxe,otherpxe.efi$/
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-option=tag:efi6,tag:!ipxe6,option6:bootfile-url,tftp:\/\/.*\/otherpxe.efi$/
        )
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-hostsdir=\/etc\/ironic-inspector\/dhcp-hostsdir$/
        )

      end
      it 'should contain file /var/www/httpboot/inspector.ipxe' do
        is_expected.to contain_file('/var/www/httpboot/inspector.ipxe').with(
          'ensure'  => 'file',
          'owner'   => 'ironic-inspector',
          'group'   => 'ironic-inspector',
          'seltype' => 'httpd_sys_content_t',
          'content' => /ipxe/,
        )
        is_expected.to contain_file('/var/www/httpboot/inspector.ipxe').with_content(
          /^kernel http:\/\/192.168.0.1:3816\/agent.kernel ipa-inspection-callback-url=http:\/\/192.168.0.1:5050\/v1\/continue ipa-inspection-collectors=default .* foo=bar || goto retry_boot$/
        )
        is_expected.to contain_file('/var/www/httpboot/inspector.ipxe').with_content(
          /^initrd http:\/\/192.168.0.1:3816\/agent.ramdisk || goto retry_boot$/
        )
      end

      context 'when ipxe_timeout is set' do
        before :each do
          params.merge!(
            :ipxe_timeout => 30,
          )
        end

        it 'should contain file /var/www/httpboot/inspector.ipxe' do
          is_expected.to contain_file('/var/www/httpboot/inspector.ipxe').with_content(
            /^kernel --timeout 30000 /
          )
          is_expected.to contain_file('/var/www/httpboot/inspector.ipxe').with_content(
            /^initrd --timeout 30000 /
          )
        end
      end

      context 'when using ipv6' do
        before :each do
          params.merge!(
            :listen_address     => 'fd00::1',
          )
        end

        it 'should contain file /var/www/httpboot/inspector.ipxe' do
          is_expected.to contain_file('/var/www/httpboot/inspector.ipxe').with_content(
            /^kernel http:\/\/\[fd00::1\]:3816\/agent.kernel ipa-inspection-callback-url=http:\/\/\[fd00::1\]:5050\/v1\/continue .* foo=bar || goto retry_boot$/
          )
          is_expected.to contain_file('/var/www/httpboot/inspector.ipxe').with_content(
            /^initrd http:\/\/\[fd00::1\]:3816\/agent.ramdisk || goto retry_boot$/
          )
        end
      end
    end

    context 'when enabling ppc64le support' do
      before do
        params.merge!(
          :enable_ppc64le => true,
        )
      end

      it 'should contain file /etc/ironic-inspector/dnsmasq.conf' do
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-match=set:ppc64le,option:client-arch,14$/)
      end
      it 'should contain directory /tftpboot/ppc64le with selinux type tftpdir_t' do
        is_expected.to contain_file('/tftpboot/ppc64le').with(
          'ensure'  => 'directory',
          'owner'   => 'ironic-inspector',
          'group'   => 'ironic-inspector',
          'seltype' => 'tftpdir_t',
        )
      end
      it 'should contain file /tftpboot/ppc64le/default' do
        is_expected.to contain_file('/tftpboot/ppc64le/default').with(
          'ensure'  => 'file',
          'owner'   => 'ironic-inspector',
          'group'   => 'ironic-inspector',
          'seltype' => 'tftpdir_t',
          'content' => /default/,
        )
        is_expected.to contain_file('/tftpboot/ppc64le/default').with_content(
          /^append initrd=agent.ramdisk ipa-inspection-callback-url=http:\/\/192.168.0.1:5050\/v1\/continue /
        )
      end
    end

    context 'when enabling ppc64le support with http default transport' do
      before do
        params.merge!(
          :enable_ppc64le        => true,
          :pxe_transfer_protocol => 'http',
        )
      end

      it 'should contain file /etc/ironic-inspector/dnsmasq.conf' do
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /^dhcp-match=set:ppc64le,option:client-arch,14$/)
      end
      it 'should contain file /tftpboot/ppc64le/default' do
        is_expected.to contain_file('/tftpboot/ppc64le/default').with(
          'ensure'  => 'file',
          'owner'   => 'ironic-inspector',
          'group'   => 'ironic-inspector',
          'seltype' => 'tftpdir_t',
          'content' => /default/,
          'tag'     => 'ironic-inspector-dnsmasq-file',
        )
        is_expected.to contain_file('/tftpboot/ppc64le/default').with_content(
          /^append initrd=agent.ramdisk ipa-inspection-callback-url=http:\/\/192.168.0.1:5050\/v1\/continue /
        )
      end
    end
  end

  shared_examples_for 'ironic inspector with non-standalone services' do
    before do
      params.merge!(
        :standalone => false
      )
    end

    it 'configures ironic-inspector.conf' do
      is_expected.to contain_ironic_inspector_config('DEFAULT/standalone').with_value(false)
    end

    it 'ensure ironic inspector packages are installed' do
      is_expected.to contain_package('ironic-inspector').with(
        :ensure => 'present',
        :name   => platform_params[:inspector_package],
        :tag    => ['openstack', 'ironic-inspector-package'],
      )
      is_expected.to contain_package('ironic-inspector-api').with(
        :ensure => 'present',
        :name   => platform_params[:inspector_api_package],
        :tag    => ['openstack', 'ironic-inspector-package'],
      )
      is_expected.to contain_package('ironic-inspector-conductor').with(
        :ensure => 'present',
        :name   => platform_params[:inspector_conductor_package],
        :tag    => ['openstack', 'ironic-inspector-package'],
      )
    end

    it 'ensure ironic inspector service is stopped' do
      is_expected.to contain_service('ironic-inspector').with(
        :ensure    => 'stopped',
        :name      => platform_params[:inspector_service],
        :enable    => false,
        :hasstatus => true,
        :tag       => 'ironic-inspector-service',
      )
    end

    it 'ensure ironic inspector conductor service is running' do
      is_expected.to contain_service('ironic-inspector-conductor').with(
        :ensure    => 'running',
        :name      => platform_params[:inspector_conductor_service],
        :enable    => true,
        :hasstatus => true,
        :tag       => 'ironic-inspector-service',
      )
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
          {
            :inspector_package => 'ironic-inspector',
            :inspector_service => 'ironic-inspector'
          }
        when 'RedHat'
          {
            :inspector_package           => 'openstack-ironic-inspector',
            :inspector_dnsmasq_package   => 'openstack-ironic-inspector-dnsmasq',
            :inspector_dnsmasq_service   => 'openstack-ironic-inspector-dnsmasq',
            :inspector_service           => 'openstack-ironic-inspector',
            :inspector_api_package       => 'openstack-ironic-inspector-api',
            :inspector_conductor_package => 'openstack-ironic-inspector-conductor',
            :inspector_conductor_service => 'openstack-ironic-inspector-conductor'
          }
        end
      end

      it_behaves_like 'ironic inspector'
      if facts[:os]['family'] == 'RedHat'
        it_behaves_like 'ironic inspector with non-standalone services'
      end
    end
  end

end
