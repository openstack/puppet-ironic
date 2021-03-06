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
# [*pxe_append_params*]
#   (optional) Additional append parameters for baremetal PXE boot.
#   Should be valid pxe parameters
#   Defaults to $::os_service_default.
#
# [*pxe_bootfile_name*]
#   (optional) Bootfile DHCP parameter.
#   If not set, its value is detected.
#   Defaults to $::os_service_default.
#
# [*pxe_config_template*]
#   (optional) Template file for PXE configuration.
#   If set, should be an valid template file. Otherwise, its value is detected.
#   Defaults to $::os_service_default.
#
# [*ipxe_bootfile_name*]
#   (optional) Bootfile DHCP parameter when the ipxe boot interface is set
#   for a baremetal node. If not set, its value is detected.
#   Defaults to $::os_service_default.
#
# [*ipxe_config_template*]
#   (optional) Template file for PXE configuration with the iPXE boot
#   interface. If set, should be an valid template file. Otherwise,
#   its value is detected.
#   Defaults to $::os_service_default.
#
# [*tftp_server*]
#   (optional) IP address of Ironic compute node's tftp server.
#   Should be an valid IP address
#   Defaults to $::os_service_default.
#
# [*tftp_root*]
#   (optional) Ironic compute node's tftp root path.
#   Should be an valid path
#   Defaults to $::os_service_default.
#
# [*images_path*]
#   (optional) Directory where images are stored on disk.
#   Should be an valid directory
#   Defaults to $::os_service_default.
#
# [*tftp_master_path*]
#   (optional) Directory where master tftp images are stored on disk.
#   Should be an valid directory
#   Defaults to $::os_service_default.
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
# [*uefi_ipxe_bootfile_name*]
#   (optional) Bootfile DHCP parameter for UEFI boot mode for the
#   ipxe boot interface. No separate configuration template is required
#   when using ipxe.
#   Defaults to snponly.efi, which supports UEFI firmware with network
#   enablement, which is a standard feature in UEFI.
#
# [*ipxe_timeout*]
#   (optional) ipxe timeout in second.
#   Should be an valid integer
#   Defaults to $::os_service_default.
#
# [*enable_ppc64le*]
#   (optional) Boolean value to dtermine if ppc64le support should be enabled
#   Defaults to false (no ppc64le support)
#
# [*boot_retry_timeout*]
#   (optional) Timeout (in seconds) after which PXE boot should be retried.
#   Defaults to $::os_service_default.
#
# [*boot_retry_check_interval*]
#   (optional) How often (in seconds) to check for PXE boot status.
#   Defaults to $::os_service_default.
#
# DEPRECATED PARAMETERS
#
# [*ipxe_enabled*]
#   DEPRECATED: This option is no longer used as support for the option was
#   deprecated during Ironic's Stein development cycle and removed during
#   Ironic's Train development cycle.
#   If this setting is populated, a warning will be indicated.
#
# [*ip_version*]
#   DEPRECATED: (optional) The IP version that will be used for PXE booting.
#   Ironic presently attempts both IPv4 and IPv6, this option is effectively
#   ignored by ironic, and should anticipate being removed in a future
#   release.
#   Defaults to $::os_service_default.
#
class ironic::drivers::pxe (
  $ipxe_enabled              = undef,
  $pxe_append_params         = $::os_service_default,
  $pxe_bootfile_name         = $::os_service_default,
  $pxe_config_template       = $::os_service_default,
  $ipxe_bootfile_name        = $::os_service_default,
  $ipxe_config_template      = $::os_service_default,
  $tftp_server               = $::os_service_default,
  $tftp_root                 = $::os_service_default,
  $images_path               = $::os_service_default,
  $tftp_master_path          = $::os_service_default,
  $instance_master_path      = $::os_service_default,
  $uefi_pxe_bootfile_name    = $::os_service_default,
  $uefi_pxe_config_template  = $::os_service_default,
  $uefi_ipxe_bootfile_name   = 'snponly.efi',
  $ipxe_timeout              = $::os_service_default,
  $enable_ppc64le            = false,
  $boot_retry_timeout        = $::os_service_default,
  $boot_retry_check_interval = $::os_service_default,
  $ip_version                = undef,
) {

  include ironic::deps
  include ironic::pxe::common

  if $ipxe_enabled != undef {
    warning('The ironic::drivers::pxe::ipxe_enabled parameter is deprecated and has no effect.')
  }

  if $ip_version != undef {
    warning('The ironic::drivers::pxe:ip_version parameter is deprecated and will be removed in the future.')
  }

  # Configure ironic.conf
  ironic_config {
    'pxe/pxe_append_params': value         => $pxe_append_params;
    'pxe/pxe_bootfile_name': value         => $pxe_bootfile_name;
    'pxe/pxe_config_template': value       => $pxe_config_template;
    'pxe/ipxe_bootfile_name': value        => $ipxe_bootfile_name;
    'pxe/ipxe_config_template': value      => $ipxe_config_template;
    'pxe/tftp_server': value               => $tftp_server;
    'pxe/tftp_root': value                 => $tftp_root;
    'pxe/images_path': value               => $images_path;
    'pxe/tftp_master_path': value          => $tftp_master_path;
    'pxe/instance_master_path': value      => $instance_master_path;
    'pxe/uefi_pxe_bootfile_name': value    => $uefi_pxe_bootfile_name;
    'pxe/uefi_pxe_config_template': value  => $uefi_pxe_config_template;
    'pxe/uefi_ipxe_bootfile_name': value   => $uefi_ipxe_bootfile_name;
    'pxe/ipxe_timeout': value              => $ipxe_timeout;
    'pxe/boot_retry_timeout': value        => $boot_retry_timeout;
    'pxe/boot_retry_check_interval': value => $boot_retry_check_interval;
    'pxe/ip_version': value                => $ip_version;
  }

  if $enable_ppc64le {
    # FXIME(tonyb): As these are really hash values it would beter to model
    # them that way.  We can do that later, probably when we add another
    # architecture
    ironic_config {
      # NOTE(tonyb): This first value shouldn't be needed but seems to be?
      # NOTE(TheJulia): Likely not needed as this just points to the default,
      # and when the explicit pxe driver is used everything should fall to
      # it but in the interest of minimizing impact, the output result
      # is preserved as we now just allow the default for normal template
      # operation to be used.
      'pxe/pxe_config_template_by_arch': value => 'ppc64le:$pybasedir/drivers/modules/pxe_config.template';
      'pxe/pxe_bootfile_name_by_arch': value   => 'ppc64le:config';
    }
  }

}
