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

  let :default_params do
    { :package_ensure                  => 'present',
      :enabled                         => true,
      :pxe_transfer_protocol           => 'tftp',
      :auth_uri                        => 'http://127.0.0.1:5000/v2.0',
      :identity_uri                    => 'http://127.0.0.1:35357',
      :admin_user                      => 'ironic',
      :admin_tenant_name               => 'services',
      :dnsmasq_interface               => 'br-ctlplane',
      :db_connection                   => 'sqlite:////var/lib/ironic-inspector/inspector.sqlite',
      :ramdisk_logs_dir                => '/var/log/ironic-inspector/ramdisk/',
      :enable_setting_ipmi_credentials => false,
      :keep_ports                      => 'all',
      :store_data                      => 'none',
      :ironic_username                 => 'ironic',
      :ironic_tenant_name              => 'services',
      :ironic_auth_url                 => 'http://127.0.0.1:5000/v2.0',
      :ironic_max_retries              => 30,
      :ironic_retry_interval           => 2,
      :swift_username                  => 'ironic',
      :swift_tenant_name               => 'services',
      :swift_auth_url                  => 'http://127.0.0.1:5000/v2.0',
      :dnsmasq_ip_range                => '192.168.0.100,192.168.0.120',
      :dnsmasq_local_ip                => '192.168.0.1', }
  end

  let :params do
    {}
  end

  shared_examples_for 'ironic inspector' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('ironic::params') }
    it { is_expected.to contain_class('ironic::inspector::logging') }

    it 'installs ironic inspector package' do
      if platform_params.has_key?(:inspector_package)
        is_expected.to contain_package('ironic-inspector').with(
          :name   => platform_params[:inspector_package],
          :ensure => p[:package_ensure],
          :tag    => ['openstack', 'ironic-inspector-package'],
        )
        is_expected.to contain_package('ironic-inspector').with_before(/Service\[ironic-inspector\]/)
      end
    end

    it 'ensure ironic inspector service is running' do
      is_expected.to contain_service('ironic-inspector').with(
        'hasstatus' => true,
        'tag'       => 'ironic-inspector-service',
      )
    end

    it 'ensure ironic inspector dnsmasq service is running' do
      is_expected.to contain_service('ironic-inspector-dnsmasq').with(
        'hasstatus' => true,
        'tag'       => 'ironic-inspector-dnsmasq-service',
      )
    end

    it 'configures inspector.conf' do
      is_expected.to contain_ironic_inspector_config('keystone_authtoken/auth_uri').with_value(p[:auth_uri])
      is_expected.to contain_ironic_inspector_config('keystone_authtoken/identity_uri').with_value(p[:identity_uri])
      is_expected.to contain_ironic_inspector_config('keystone_authtoken/admin_user').with_value(p[:admin_user])
      is_expected.to contain_ironic_inspector_config('keystone_authtoken/admin_tenant_name').with_value(p[:admin_tenant_name])
      is_expected.to contain_ironic_inspector_config('firewall/dnsmasq_interface').with_value(p[:dnsmasq_interface])
      is_expected.to contain_ironic_inspector_config('database/connection').with_value(p[:db_connection])
      is_expected.to contain_ironic_inspector_config('processing/ramdisk_logs_dir').with_value(p[:ramdisk_logs_dir])
      is_expected.to contain_ironic_inspector_config('processing/enable_setting_ipmi_credentials').with_value(p[:enable_setting_ipmi_credentials])
      is_expected.to contain_ironic_inspector_config('processing/keep_ports').with_value(p[:keep_ports])
      is_expected.to contain_ironic_inspector_config('processing/store_data').with_value(p[:store_data])
      is_expected.to contain_ironic_inspector_config('ironic/os_username').with_value(p[:ironic_username])
      is_expected.to contain_ironic_inspector_config('ironic/os_tenant_name').with_value(p[:ironic_tenant_name])
      is_expected.to contain_ironic_inspector_config('ironic/os_auth_url').with_value(p[:ironic_auth_url])
      is_expected.to contain_ironic_inspector_config('ironic/max_retries').with_value(p[:ironic_max_retries])
      is_expected.to contain_ironic_inspector_config('ironic/retry_interval').with_value(p[:ironic_retry_interval])
      is_expected.to contain_ironic_inspector_config('swift/username').with_value(p[:swift_username])
      is_expected.to contain_ironic_inspector_config('swift/tenant_name').with_value(p[:swift_tenant_name])
      is_expected.to contain_ironic_inspector_config('swift/os_auth_url').with_value(p[:swift_auth_url])
      is_expected.to contain_ironic_inspector_config('processing/processing_hooks').with_value('$default_processing_hooks')
    end

    it 'should contain file /etc/ironic-inspector/dnsmasq.conf' do
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with(
        'ensure'  => 'present',
        'require' => 'Package[ironic-inspector]',
        'content' => /pxelinux/,
      )
    end
    it 'should contain file /tftpboot/pxelinux.cfg/default' do
      is_expected.to contain_file('/tftpboot/pxelinux.cfg/default').with(
        'ensure'  => 'present',
        'require' => 'Package[ironic-inspector]',
        'content' => /default/,
      )
      is_expected.to contain_file('/tftpboot/pxelinux.cfg/default').with_content(
          /initrd=agent.ramdisk ipa-inspection-callback-url=http:\/\/192.168.0.1:5050\/v1\/continue ipa-inspection-collectors=default/
      )
    end
    it 'should contain directory /tftpboot with selinux type tftpdir_t' do
      is_expected.to contain_file('/tftpboot').with(
        'ensure'  => 'directory',
        'seltype' => 'tftpdir_t'
      )
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :debug                        => true,
          :auth_uri                     => 'http://192.168.0.1:5000/v2.0',
          :identity_uri                 => 'http://192.168.0.1:35357',
          :admin_password               => 'password',
          :ironic_password              => 'password',
          :ironic_auth_url              => 'http://192.168.0.1:5000/v2.0',
          :swift_password               => 'password',
          :swift_auth_url               => 'http://192.168.0.1:5000/v2.0',
          :pxe_transfer_protocol        => 'http',
          :additional_processing_hooks  => 'hook1,hook2',
          :ramdisk_kernel_args          => 'foo=bar',
        )
      end
      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_inspector_config('DEFAULT/debug').with_value(p[:debug])
        is_expected.to contain_ironic_inspector_config('keystone_authtoken/auth_uri').with_value(p[:auth_uri])
        is_expected.to contain_ironic_inspector_config('keystone_authtoken/identity_uri').with_value(p[:identity_uri])
        is_expected.to contain_ironic_inspector_config('keystone_authtoken/admin_password').with_value(p[:admin_password])
        is_expected.to contain_ironic_inspector_config('ironic/os_password').with_value(p[:ironic_password])
        is_expected.to contain_ironic_inspector_config('ironic/os_auth_url').with_value(p[:ironic_auth_url])
        is_expected.to contain_ironic_inspector_config('swift/password').with_value(p[:swift_password])
        is_expected.to contain_ironic_inspector_config('swift/os_auth_url').with_value(p[:swift_auth_url])
        is_expected.to contain_ironic_inspector_config('processing/processing_hooks').with_value('$default_processing_hooks,hook1,hook2')
      end

      it 'should contain file /etc/ironic-inspector/dnsmasq.conf' do
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with(
          'ensure'  => 'present',
          'require' => 'Package[ironic-inspector]',
          'content' => /ipxe/,
        )
      end
      it 'should contain file /httpboot/inspector.ipxe' do
        is_expected.to contain_file('/httpboot/inspector.ipxe').with(
          'ensure'  => 'present',
          'require' => 'Package[ironic-inspector]',
          'content' => /ipxe/,
        )
        is_expected.to contain_file('/httpboot/inspector.ipxe').with_content(
            /kernel http:\/\/192.168.0.1:8088\/agent.kernel ipa-inspection-callback-url=http:\/\/192.168.0.1:5050\/v1\/continue ipa-inspection-collectors=default.* foo=bar/
        )
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'Debian' })
    end

    let :platform_params do
      { :inspector_package => 'ironic-inspector',
        :inspector_service => 'ironic-inspector' }
    end

    it_configures 'ironic inspector'
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    let :platform_params do
      { :inspector_service => 'ironic-inspector' }
    end

    it_configures 'ironic inspector'
  end

end
