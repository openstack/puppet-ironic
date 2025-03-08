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
# [*kernel_append_params*]
#   (optional) Additional append parameters for baremetal PXE boot.
#   Should be valid pxe parameters
#   Defaults to $facts['os_service_default'].
#
# [*pxe_bootfile_name*]
#   (optional) Bootfile DHCP parameter.
#   If not set, its value is detected.
#   Defaults to $facts['os_service_default'].
#
# [*pxe_config_template*]
#   (optional) Template file for PXE configuration.
#   If set, should be an valid template file. Otherwise, its value is detected.
#   Defaults to $facts['os_service_default'].
#
# [*ipxe_bootfile_name*]
#   (optional) Bootfile DHCP parameter when the ipxe boot interface is set
#   for a baremetal node. If not set, its value is detected.
#   Defaults to $facts['os_service_default'].
#
# [*ipxe_config_template*]
#   (optional) Template file for PXE configuration with the iPXE boot
#   interface. If set, should be an valid template file. Otherwise,
#   its value is detected.
#   Defaults to $facts['os_service_default'].
#
# [*tftp_server*]
#   (optional) IP address of Ironic compute node's tftp server.
#   Should be an valid IP address
#   Defaults to $facts['os_service_default'].
#
# [*tftp_root*]
#   (optional) Ironic compute node's tftp root path.
#   Should be an valid path
#   Defaults to '/tftpboot'.
#
# [*images_path*]
#   (optional) Directory where images are stored on disk.
#   Should be an valid directory
#   Defaults to $facts['os_service_default'].
#
# [*tftp_master_path*]
#   (optional) Directory where master tftp images are stored on disk.
#   Should be an valid directory
#   Defaults to $facts['os_service_default'].
#
# [*instance_master_path*]
#   (optional) Directory where master tftp images are stored on disk.
#   Should be an valid directory
#   Defaults to $facts['os_service_default'].
#
# [*uefi_pxe_bootfile_name*]
#   (optional) Bootfile DHCP parameter for UEFI boot mode for the
#   pxe boot interface. No separate configuration template is required
#   when using ipxe.
#   Defaults to bootx64.efi, which will be the signed shim that loads
#   grub for a network boot.
#
# [*uefi_pxe_config_template*]
#   (optional) Template file for PXE configuration for UEFI boot loader.
#   Defaults to $facts['os_service_default'].
#
# [*uefi_ipxe_bootfile_name*]
#   (optional) Bootfile DHCP parameter for UEFI boot mode for the
#   ipxe boot interface. No separate configuration template is required
#   when using ipxe.
#   Defaults to $::ironic::params::uefi_ipxe_bootfile_name
#
# [*ipxe_timeout*]
#   (optional) ipxe timeout in second.
#   Should be an valid integer
#   Defaults to $facts['os_service_default'].
#
# [*boot_retry_timeout*]
#   (optional) Timeout (in seconds) after which PXE boot should be retried.
#   Defaults to $facts['os_service_default'].
#
# [*boot_retry_check_interval*]
#   (optional) How often (in seconds) to check for PXE boot status.
#   Defaults to $facts['os_service_default'].
#
# [*dir_permission*]
#   (optional) THe permission that will be applied to the TFTP folders upon
#   creation.
#   Defaults to $facts['os_service_default'].
#
# [*file_permission*]
#   (optional) The permission which is used on files created as part of
#   configuration and setup of file assets for PXE based operations.
#   Defaults to $facts['os_service_default'].
#
# [*loader_file_paths*]
#   (optional) Dictionary describing the bootloaders to load into conductor
#   PXE/iXPE boot folders values from the host operating system.
#   Defaults to $facts['os_service_default'].
#
# [*pxe_bootfile_name_by_arch*]
#   (optional) Bootfile DHCP parameter per node architecture.
#   Defaults to $facts['os_service_default'].
#
# [*ipxe_bootfile_name_by_arch*]
#   (optional) Bootfile DHCP parameter per node architecture.
#   Defaults to $facts['os_service_default'].
#
# [*pxe_config_template_by_arch*]
#   (optional) Template file for PXE configuration per node architecture.
#   Defaults to $facts['os_service_default'].
#
class ironic::drivers::pxe (
  $kernel_append_params              = $facts['os_service_default'],
  $pxe_bootfile_name                 = $facts['os_service_default'],
  $pxe_config_template               = $facts['os_service_default'],
  $ipxe_bootfile_name                = $facts['os_service_default'],
  $ipxe_config_template              = $facts['os_service_default'],
  $tftp_server                       = $facts['os_service_default'],
  Stdlib::Absolutepath $tftp_root    = '/tftpboot',
  $images_path                       = $facts['os_service_default'],
  $tftp_master_path                  = $facts['os_service_default'],
  $instance_master_path              = $facts['os_service_default'],
  String[1] $uefi_pxe_bootfile_name  = $::ironic::params::uefi_pxe_bootfile_name,
  $uefi_pxe_config_template          = $facts['os_service_default'],
  String[1] $uefi_ipxe_bootfile_name = $::ironic::params::uefi_ipxe_bootfile_name,
  $ipxe_timeout                      = $facts['os_service_default'],
  $boot_retry_timeout                = $facts['os_service_default'],
  $boot_retry_check_interval         = $facts['os_service_default'],
  $dir_permission                    = $facts['os_service_default'],
  $file_permission                   = $facts['os_service_default'],
  $loader_file_paths                 = $facts['os_service_default'],
  $pxe_bootfile_name_by_arch         = $facts['os_service_default'],
  $ipxe_bootfile_name_by_arch        = $facts['os_service_default'],
  $pxe_config_template_by_arch       = $facts['os_service_default'],
) inherits ironic::params {

  include ironic::deps

  include ironic::pxe::common
  $tftp_root_real               = pick($::ironic::pxe::common::tftp_root, $tftp_root)
  $ipxe_timeout_real            = pick($::ironic::pxe::common::ipxe_timeout, $ipxe_timeout)
  $uefi_ipxe_bootfile_name_real = pick($::ironic::pxe::common::uefi_ipxe_bootfile_name, $uefi_ipxe_bootfile_name)
  $uefi_pxe_bootfile_name_real = pick($::ironic::pxe::common::uefi_pxe_bootfile_name, $uefi_pxe_bootfile_name)

  $loader_file_paths_real = $loader_file_paths ? {
    Hash    => join(join_keys_to_values($loader_file_paths, ':'), ','),
    default => join(any2array($loader_file_paths), ',')
  }

  # Configure ironic.conf
  ironic_config {
    'pxe/kernel_append_params':      value => $kernel_append_params;
    'pxe/pxe_bootfile_name':         value => $pxe_bootfile_name;
    'pxe/pxe_config_template':       value => $pxe_config_template;
    'pxe/ipxe_bootfile_name':        value => $ipxe_bootfile_name;
    'pxe/ipxe_config_template':      value => $ipxe_config_template;
    'pxe/tftp_server':               value => $tftp_server;
    'pxe/tftp_root':                 value => $tftp_root_real;
    'pxe/images_path':               value => $images_path;
    'pxe/tftp_master_path':          value => $tftp_master_path;
    'pxe/instance_master_path':      value => $instance_master_path;
    'pxe/uefi_pxe_bootfile_name':    value => $uefi_pxe_bootfile_name_real;
    'pxe/uefi_pxe_config_template':  value => $uefi_pxe_config_template;
    'pxe/uefi_ipxe_bootfile_name':   value => $uefi_ipxe_bootfile_name_real;
    'pxe/ipxe_timeout':              value => $ipxe_timeout_real;
    'pxe/boot_retry_timeout':        value => $boot_retry_timeout;
    'pxe/boot_retry_check_interval': value => $boot_retry_check_interval;
    'pxe/dir_permission':            value => $dir_permission;
    'pxe/file_permission':           value => $file_permission;
    'pxe/loader_file_paths':         value => $loader_file_paths_real;
  }

  $pxe_bootfile_name_by_arch_real = $pxe_bootfile_name_by_arch ? {
    Hash    => join(join_keys_to_values($pxe_bootfile_name_by_arch, ':'), ','),
    default => join(any2array($pxe_bootfile_name_by_arch), ',')
  }
  $ipxe_bootfile_name_by_arch_real = $ipxe_bootfile_name_by_arch ? {
    Hash    => join(join_keys_to_values($ipxe_bootfile_name_by_arch, ':'), ','),
    default => join(any2array($ipxe_bootfile_name_by_arch), ',')
  }
  $pxe_config_template_by_arch_real = $pxe_config_template_by_arch ? {
    Hash    => join(join_keys_to_values($pxe_config_template_by_arch, ':'), ','),
    default => join(any2array($pxe_config_template_by_arch), ',')
  }

  ironic_config {
    'pxe/pxe_config_template_by_arch': value => $pxe_config_template_by_arch_real;
    'pxe/pxe_bootfile_name_by_arch':   value => $pxe_bootfile_name_by_arch_real;
    'pxe/ipxe_bootfile_name_by_arch':  value => $ipxe_bootfile_name_by_arch_real;
  }

}
