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
# Unit tests for ironic::drivers::pxe class
#

require 'spec_helper'

describe 'ironic::drivers::pxe' do

  let :default_params do
    { :tftp_root                => '/tftpboot',
      :tftp_master_path         => '/tftpboot/master_images',
      :uefi_ipxe_bootfile_name  => 'ipxe.efi',
    }
  end

  let :params do
    {}
  end

  shared_examples_for 'ironic pxe driver' do
    let :p do
      default_params.merge(params)
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('pxe/pxe_append_params').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/pxe_bootfile_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/pxe_config_template').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/ipxe_bootfile_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/ipxe_config_template').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/tftp_server').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/tftp_root').with_value(p[:tftp_root])
      is_expected.to contain_ironic_config('pxe/images_path').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/tftp_master_path').with_value(p[:tftp_master_path])
      is_expected.to contain_ironic_config('pxe/instance_master_path').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/uefi_pxe_bootfile_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/uefi_pxe_config_template').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/uefi_ipxe_bootfile_name').with_value('ipxe.efi')
      is_expected.to contain_ironic_config('pxe/ipxe_enabled').with_value(false)
    end

    context 'when overriding only ipxe_enabled' do
      before do
        params.merge!(
          :ipxe_enabled             => true,
        )
      end

      it 'detects correct boot parameters' do
        is_expected.to contain_ironic_config('pxe/pxe_append_params').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/pxe_bootfile_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/pxe_config_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/ipxe_bootfile_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/ipxe_config_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/tftp_server').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/tftp_root').with_value(p[:tftp_root])
        is_expected.to contain_ironic_config('pxe/images_path').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/tftp_master_path').with_value(p[:tftp_master_path])
        is_expected.to contain_ironic_config('pxe/instance_master_path').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/uefi_pxe_bootfile_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/uefi_pxe_config_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('pxe/uefi_ipxe_bootfile_name').with_value('ipxe.efi')
        is_expected.to contain_ironic_config('pxe/ipxe_enabled').with_value(true)
      end
    end

    context 'when overriding only enable_ppc64le' do
      before do
        params.merge!(
          :enable_ppc64le             => true,
        )
      end

      it 'detects correct ppc64le parameters' do
        is_expected.to contain_ironic_config('pxe/pxe_config_template_by_arch').with_value('ppc64le:$pybasedir/drivers/modules/pxe_config.template')
        is_expected.to contain_ironic_config('pxe/pxe_bootfile_name_by_arch').with_value('ppc64le:config')
      end
    end

    context 'when overriding parameters' do
      before do
        params.merge!(
          :pxe_append_params         => 'foo',
          :pxe_config_template       => 'bar',
          :tftp_server               => '192.168.0.1',
          :tftp_root                 => '/mnt/ftp',
          :images_path               => '/mnt/images',
          :tftp_master_path          => '/mnt/master_images',
          :instance_master_path      => '/mnt/ironic/master_images',
          :uefi_pxe_bootfile_name    => 'bootx64.efi',
          :uefi_ipxe_bootfile_name   => 'snponly.efi',
          :uefi_pxe_config_template  => 'foo-uefi',
          :ipxe_timeout              => '60',
          :ipxe_enabled              => true,
          :pxe_bootfile_name         => 'bootx64',
          :boot_retry_timeout        => 600,
          :boot_retry_check_interval => 120,
          :ip_version                => 6,
        )
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('pxe/pxe_append_params').with_value(p[:pxe_append_params])
        is_expected.to contain_ironic_config('pxe/pxe_config_template').with_value(p[:pxe_config_template])
        is_expected.to contain_ironic_config('pxe/tftp_server').with_value(p[:tftp_server])
        is_expected.to contain_ironic_config('pxe/tftp_root').with_value(p[:tftp_root])
        is_expected.to contain_ironic_config('pxe/images_path').with_value(p[:images_path])
        is_expected.to contain_ironic_config('pxe/tftp_master_path').with_value(p[:tftp_master_path])
        is_expected.to contain_ironic_config('pxe/instance_master_path').with_value(p[:instance_master_path])
        is_expected.to contain_ironic_config('pxe/uefi_pxe_bootfile_name').with_value(p[:uefi_pxe_bootfile_name])
        is_expected.to contain_ironic_config('pxe/uefi_pxe_config_template').with_value(p[:uefi_pxe_config_template])
        is_expected.to contain_ironic_config('pxe/uefi_ipxe_bootfile_name').with_value(p[:uefi_ipxe_bootfile_name])
        is_expected.to contain_ironic_config('pxe/ipxe_timeout').with_value(p[:ipxe_timeout])
        is_expected.to contain_ironic_config('pxe/ipxe_enabled').with_value(p[:ipxe_enabled])
        is_expected.to contain_ironic_config('pxe/pxe_bootfile_name').with_value(p[:pxe_bootfile_name])
        is_expected.to contain_ironic_config('pxe/boot_retry_timeout').with_value(p[:boot_retry_timeout])
        is_expected.to contain_ironic_config('pxe/boot_retry_check_interval').with_value(p[:boot_retry_check_interval])
        is_expected.to contain_ironic_config('pxe/ip_version').with_value(p[:ip_version])
      end
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir         => '/var/lib/puppet/concat',
          :fqdn                   => 'some.host.tld',
        }))
      end

      it_behaves_like 'ironic pxe driver'

    end
  end

end
