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

  let :params do
    {}
  end

  shared_examples_for 'ironic pxe driver' do
    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('pxe/kernel_append_params').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/pxe_bootfile_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/pxe_config_template').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/ipxe_bootfile_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/ipxe_config_template').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/tftp_server').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/tftp_root').with_value('/tftpboot')
      is_expected.to contain_ironic_config('pxe/images_path').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/tftp_master_path').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/instance_master_path').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/uefi_pxe_config_template').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/uefi_ipxe_bootfile_name').with_value(platform_params[:uefi_ipxe_bootfile_name])
      is_expected.to contain_ironic_config('pxe/uefi_pxe_bootfile_name').with_value('bootx64.efi')
      is_expected.to contain_ironic_config('pxe/dir_permission').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/file_permission').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/loader_file_paths').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('pxe/ipxe_enabled').with_ensure('absent')
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
          :kernel_append_params      => 'foo',
          :pxe_config_template       => 'bar',
          :tftp_server               => '192.168.0.1',
          :tftp_root                 => '/mnt/ftp',
          :images_path               => '/mnt/images',
          :tftp_master_path          => '/mnt/master_images',
          :instance_master_path      => '/mnt/ironic/master_images',
          :uefi_ipxe_bootfile_name    => 'ipxe.efi',
          :uefi_pxe_bootfile_name    => 'shim-x64.efi',
          :uefi_pxe_config_template  => 'foo-uefi',
          :ipxe_timeout              => '60',
          :pxe_bootfile_name         => 'bootx64',
          :boot_retry_timeout        => 600,
          :boot_retry_check_interval => 120,
          :dir_permission            => '0o755',
          :file_permission           => '0o644',
          :loader_file_paths         => ['ipxe.efi:/usr/share/ipxe/ipxe-snponly-x86_64.efi',
                                         'undionly.kpxe:/usr/share/ipxe/undionly.kpxe'],
          :ip_version                => 6,
        )
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('pxe/kernel_append_params').with_value(params[:kernel_append_params])
        is_expected.to contain_ironic_config('pxe/pxe_config_template').with_value(params[:pxe_config_template])
        is_expected.to contain_ironic_config('pxe/tftp_server').with_value(params[:tftp_server])
        is_expected.to contain_ironic_config('pxe/tftp_root').with_value(params[:tftp_root])
        is_expected.to contain_ironic_config('pxe/images_path').with_value(params[:images_path])
        is_expected.to contain_ironic_config('pxe/tftp_master_path').with_value(params[:tftp_master_path])
        is_expected.to contain_ironic_config('pxe/instance_master_path').with_value(params[:instance_master_path])
        is_expected.to contain_ironic_config('pxe/uefi_pxe_bootfile_name').with_value(params[:uefi_pxe_bootfile_name])
        is_expected.to contain_ironic_config('pxe/uefi_pxe_config_template').with_value(params[:uefi_pxe_config_template])
        is_expected.to contain_ironic_config('pxe/uefi_ipxe_bootfile_name').with_value(params[:uefi_ipxe_bootfile_name])
        is_expected.to contain_ironic_config('pxe/ipxe_timeout').with_value(params[:ipxe_timeout])
        is_expected.to contain_ironic_config('pxe/pxe_bootfile_name').with_value(params[:pxe_bootfile_name])
        is_expected.to contain_ironic_config('pxe/boot_retry_timeout').with_value(params[:boot_retry_timeout])
        is_expected.to contain_ironic_config('pxe/boot_retry_check_interval').with_value(params[:boot_retry_check_interval])
        is_expected.to contain_ironic_config('pxe/dir_permission').with_value('0o755')
        is_expected.to contain_ironic_config('pxe/file_permission').with_value('0o644')
        is_expected.to contain_ironic_config('pxe/loader_file_paths')
          .with_value('ipxe.efi:/usr/share/ipxe/ipxe-snponly-x86_64.efi,undionly.kpxe:/usr/share/ipxe/undionly.kpxe')
        is_expected.to contain_ironic_config('pxe/ip_version').with_value(params[:ip_version])
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
        { :uefi_ipxe_bootfile_name => 'snponly.efi' }
      end

      it_behaves_like 'ironic pxe driver'

    end
  end

end
