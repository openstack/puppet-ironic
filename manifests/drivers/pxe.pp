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

# Configure the PXE driver in Ironic
#
# === Parameters
#
# [*ipxe_enabled*]
#   (optional) Enable ipxe support
#   Defaults to false.
#
# [*pxe_append_params*]
#   (optional) Additional append parameters for baremetal PXE boot.
#   Should be valid pxe parameters
#   Defaults to $::os_service_default
#
# [*pxe_bootfile_name*]
#   (optional) Bootfile DHCP parameter.
#   If not set, its value is detected based on ipxe_enabled.
#   Defaults to undef.
#
# [*pxe_config_template*]
#   (optional) Template file for PXE configuration.
#   If set, should be an valid template file. Otherwise, its value is detected
#   based on ipxe_enabled.
#   Defaults to undef.
#
# [*tftp_server*]
#   (optional) IP address of Ironic compute node's tftp server.
#   Should be an valid IP address
#   Defaults to $::os_service_default.
#
# [*tftp_root*]
#   (optional) Ironic compute node's tftp root path.
#   Should be an valid path
#   Defaults to '/tftpboot'.
#
# [*images_path*]
#   (optional) Directory where images are stored on disk.
#   Should be an valid directory
#   Defaults to $::os_service_default.
#
# [*tftp_master_path*]
#   (optional) Directory where master tftp images are stored on disk.
#   Should be an valid directory
#   Defaults to '/tftpboot/master_images'.
#
# [*instance_master_path*]
#   (optional) Directory where master tftp images are stored on disk.
#   Should be an valid directory
#   Defaults to $::os_service_default.
#
# [*uefi_pxe_bootfile_name*]
#   (optional) Bootfile DHCP parameter for UEFI boot mode.
#   Defaults to $::os_service_default.
#
# [*uefi_pxe_config_template*]
#   (optional) Template file for PXE configuration for UEFI boot loader.
#   Defaults to $::os_service_default.
#
# [*ipxe_timeout*]
#   (optional) ipxe timeout in second.
#   Should be an valid integer
#   Defaults to $::os_service_default.
#
class ironic::drivers::pxe (
  $ipxe_enabled             = false,
  $pxe_append_params        = $::os_service_default,
  $pxe_bootfile_name        = undef,
  $pxe_config_template      = undef,
  $tftp_server              = $::os_service_default,
  $tftp_root                = '/tftpboot',
  $images_path              = $::os_service_default,
  $tftp_master_path         = '/tftpboot/master_images',
  $instance_master_path     = $::os_service_default,
  $uefi_pxe_bootfile_name   = $::os_service_default,
  $uefi_pxe_config_template = $::os_service_default,
  $ipxe_timeout             = $::os_service_default,
) {

  include ::ironic::deps
  include ::ironic::pxe::common
  $tftp_root_real    = pick($::ironic::pxe::common::tftp_root, $tftp_root)
  $ipxe_timeout_real = pick($::ironic::pxe::common::ipxe_timeout, $ipxe_timeout)

  if $ipxe_enabled {
    $pxe_bootfile_name_real = pick($pxe_bootfile_name, 'undionly.kpxe')
    $pxe_config_template_real = pick($pxe_config_template, '$pybasedir/drivers/modules/ipxe_config.template')
  } else {
    $pxe_bootfile_name_real = pick($pxe_bootfile_name, 'pxelinux.0')
    $pxe_config_template_real = pick($pxe_config_template, '$pybasedir/drivers/modules/pxe_config.template')
  }

  # Configure ironic.conf
  ironic_config {
    'pxe/ipxe_enabled': value             => $ipxe_enabled;
    'pxe/pxe_append_params': value        => $pxe_append_params;
    'pxe/pxe_bootfile_name': value        => $pxe_bootfile_name_real;
    'pxe/pxe_config_template': value      => $pxe_config_template_real;
    'pxe/tftp_server': value              => $tftp_server;
    'pxe/tftp_root': value                => $tftp_root_real;
    'pxe/images_path': value              => $images_path;
    'pxe/tftp_master_path': value         => $tftp_master_path;
    'pxe/instance_master_path': value     => $instance_master_path;
    'pxe/uefi_pxe_bootfile_name': value   => $uefi_pxe_bootfile_name;
    'pxe/uefi_pxe_config_template': value => $uefi_pxe_config_template;
    'pxe/ipxe_timeout': value             => $ipxe_timeout_real;
  }

}
