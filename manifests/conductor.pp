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

# Configure the conductor service in Ironic
#
# === Parameters
#
# [*package_ensure*]
#   (optional) Control the ensure parameter for the package resource.
#   Defaults to 'present'.
#
# [*enabled*]
#   (optional) Define if the service must be enabled or not.
#   Defaults to true.
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*enabled_hardware_types*]
#  (optional) Array of hardware types to load during service initialization.
#  Defaults to $facts['os_service_default']
#
# [*force_power_state_during_sync*]
#   (optional) Should the hardware power state be set to the state recorded in
#   the database (True) or should the database be updated based on the hardware
#   state (False).
#   Defaults to $facts['os_service_default']
#
# [*http_url*]
#   (optional) ironic-conductor node's HTTP server URL.
#   Defaults to $facts['os_service_default']
#
# [*http_root*]
#   (optional) ironic-conductor node's HTTP root path.
#   Defaults to '/httpboot'
#
# [*force_raw_images*]
#   (optional) If true, convert backing images to "raw" disk image format.
#   Defaults to $facts['os_service_default']
#
# [*automated_clean*]
#   (optional) Whether to enable automated cleaning on nodes.
#   Defaults to $facts['os_service_default']
#
# [*cleaning_network*]
#   (optional) UUID or name of the network to create Neutron ports on, when
#   booting to a ramdisk for cleaning using Neutron DHCP.
#   Defaults to $facts['os_service_default']
#
# [*cleaning_disk_erase*]
#   (optional) Whether and how to erase hard drives during automated cleaning.
#   Accepts the following values:
#   * full - erase all data from all disks,
#   * metadata - erase only metadata (partitioning table, etc),
#   * none - do not erase anything (dangerous, use with caution).
#   Defaults to undef, which leaves the configuration intact
#
# [*continue_if_disk_secure_erase_fails*]
#   (optional) Whether to continue with shredding the hard drive if secure ATA
#   erasure fails. Only makes sense if full hard disk erasing is enabled.
#   Defaults to $facts['os_service_default']
#
# [*provisioning_network*]
#   (optional) Neutron network UUID or name for the ramdisk to be booted into
#   for provisioning nodes. Required for neutron network interface.
#   Defaults to $facts['os_service_default']
#
# [*rescuing_network*]
#   (optional) Neutron network UUID or name for the ramdisk to be booted into
#   for rescue.
#   Defaults to $facts['os_service_default']
#
# [*inspection_network*]
#   (optional) Neutron network UUID or name for the ramdisk to be booted into
#   for in-band inspection.
#   Defaults to $facts['os_service_default']
#
# [*configdrive_use_object_store*]
#   (optional) Whether to use object store for storing config drives instead of
#   the database. Recommended for bigger config drives.
#   Defaults to $facts['os_service_default']
#
# [*configdrive_swift_container*]
#   (optional) Swift container to use for storing config drives if
#   configdrive_use_object_store is true.
#   Defaults to $facts['os_service_default']
#
# [*inspect_wait_timeout*]
#   (optional) Timeout (seconds) for waiting for node inspection.
#   0 for unlimited.
#   Defaults to $facts['os_service_default']
#
# [*default_boot_option*]
#   (optional) Default boot option to use when no boot option is explicitly
#   requested. One of "netboot" or "local".
#   Defaults to $facts['os_service_default']
#
# [*default_boot_mode*]
#   (optional) Default boot mode to use when no boot mode is explicitly
#   requested in node's driver_info, capabilities or in the "instance_info"
#   configuration.requested. One of "bios" or "uefi".
#   Defaults to $facts['os_service_default']
#
# [*port_setup_delay*]
#   (optional) Delay value to wait for Neutron agents to setup
#   sufficient DHCP configuration for port.
#   Defaults to $facts['os_service_default']
#
# [*soft_power_off_timeout*]
#   (optional) Timeout (in seconds) of soft reboot and soft power off
#   operation.
#   Defaults to $facts['os_service_default']
#
# [*power_state_change_timeout*]
#   (optional) Timeout value to wait for a power operation to complete,
#   so that the baremetal node is in the desired new power state.
#   Defaults to $facts['os_service_default']
#
# [*sync_power_state_interval*]
#   (optional) Interval between syncing the node power state to the database,
#   in seconds.
#   Defaults to $facts['os_service_default']
#
# [*sync_power_state_workers*]
#   (optional) Number of worker threads syncing the node power state to the
#   database.
#   Defaults to $facts['os_service_default']
#
# [*power_state_sync_max_retries*]
#   (optional) The number of times Ironic should try syncing the hardware node
#   power state with the node power state in the database.
#   Defaults to $facts['os_service_default']
#
# [*power_failure_recovery_interval*]
#   (optional) Interval (in seconds) between checking the power
#   state for nodes previously put into maintenance mode due to power
#   synchronization failure.
#   Defaults to $facts['os_service_default']
#
# [*periodic_max_workers*]
#   (optional) Maximum number of worker threads that can be started
#   simultaneously by a periodic task.
#   Defaults to $facts['os_service_default']
#
# [*conductor_group*]
#   (optional) Name of the conductor group to join. This conductor will only
#   manage nodes with a matching "conductor_group" field set on the node.
#   Defaults to $facts['os_service_default']
#
# [*deploy_kernel*]
#   (optional) Glance UUID, http:// or file:// URL of the kernel of
#   the default deploy image.
#   Defaults to $facts['os_service_default']
#
# [*deploy_ramdisk*]
#   (optional) Glance UUID, http:// or file:// URL of the initramfs of
#   the default deploy image.
#   Defaults to $facts['os_service_default']
#
# [*deploy_kernel_by_arch*]
#   (optional) A dictionary of key-value paris of each architecture with
#   tle Glance ID, http:// or file:// URL of the kernel of the default
#   deploy image.
#   Defaults to $facts['os_service_default']
#
# [*deploy_ramdisk_by_arch*]
#   (optional) A dictionary of key-value paris of each architecture with
#   tle Glance ID, http:// or file:// URL of the initramfs of the default
#   deploy image.
#   Defaults to $facts['os_service_default']
#
# [*rescue_kernel*]
#   (optional) Glance UUID, http:// or file:// URL of the kernel of
#   the default rescue image.
#   Defaults to $facts['os_service_default']
#
# [*rescue_ramdisk*]
#   (optional) Glance UUID, http:// or file:// URL of the initramfs of
#   the default rescue image.
#   Defaults to $facts['os_service_default']
#
# [*rescue_kernel_by_arch*]
#   (optional) A dictionary of key-value paris of each architecture with
#   tle Glance ID, http:// or file:// URL of the kernel of the default
#   rescue image.
#   Defaults to $facts['os_service_default']
#
# [*rescue_ramdisk_by_arch*]
#   (optional) A dictionary of key-value paris of each architecture with
#   tle Glance ID, http:// or file:// URL of the initramfs of the default
#   rescue image.
#   Defaults to $facts['os_service_default']
#
# [*bootloader*]
#   (optional) Glance ID, http:// or file:// URL of the EFI system partition
#   image containing EFI boot loader.
#   Defaults to $facts['os_service_default']
#
# [*allow_provisioning_in_maintenance*]
#   (optional) Whether to allow nodes to enter or undergo deploy or cleaning
#   when in maintenance mode. If this option is set to False, and a node enters
#   maintenance during deploy or cleaning, the process will be aborted
#   after the next heartbeat.
#   Defaults to $facts['os_service_default']
#
# [*image_download_concurrency*]
#   (optional) How many image downloads and raw format conversion to run in
#   parallel.
#   Defaults to $facts['os_service_default']
#
# [*deploy_callback_timeout*]
#   (optional) Timeout (seconds) to wait for a callback from a deploy
#   ramdisk. Set to 0 to disable timeout. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*heartbeat_interval*]
#   (optional) Seconds between conductor heart beats.
#   Defaults to $facts['os_service_default']
#
# [*heartbeat_timeout*]
#   (optional) Maximum time (in seconds) since the last check-in of
#   a conductor.
#   Defaults to $facts['os_service_default']
#
# [*max_concurrent_deploy*]
#   (optional) The maximum number of concurrent nodes in deployment which are
#   permitted in this Ironic system.
#   Defaults to $facts['os_service_default']
#
# [*max_concurrent_clean*]
#   (optional) The maximum number of concurrent nodes in cleaning which are
#   permitted in this Ironic system.
#   Defaults to $facts['os_service_default']
#
class ironic::conductor (
  $package_ensure                      = 'present',
  Boolean $enabled                     = true,
  Boolean $manage_service              = true,
  $enabled_hardware_types              = $facts['os_service_default'],
  $force_power_state_during_sync       = $facts['os_service_default'],
  $http_url                            = $facts['os_service_default'],
  Stdlib::Absolutepath $http_root      = '/httpboot',
  $force_raw_images                    = $facts['os_service_default'],
  $automated_clean                     = $facts['os_service_default'],
  $cleaning_network                    = $facts['os_service_default'],
  Optional[Enum['full', 'metadata', 'none']] $cleaning_disk_erase
    = undef,
  $continue_if_disk_secure_erase_fails = $facts['os_service_default'],
  $provisioning_network                = $facts['os_service_default'],
  $rescuing_network                    = $facts['os_service_default'],
  $inspection_network                  = $facts['os_service_default'],
  $configdrive_use_object_store        = $facts['os_service_default'],
  $configdrive_swift_container         = $facts['os_service_default'],
  $inspect_wait_timeout                = $facts['os_service_default'],
  $default_boot_option                 = $facts['os_service_default'],
  $default_boot_mode                   = $facts['os_service_default'],
  $port_setup_delay                    = $facts['os_service_default'],
  $soft_power_off_timeout              = $facts['os_service_default'],
  $power_state_change_timeout          = $facts['os_service_default'],
  $sync_power_state_interval           = $facts['os_service_default'],
  $sync_power_state_workers            = $facts['os_service_default'],
  $power_state_sync_max_retries        = $facts['os_service_default'],
  $power_failure_recovery_interval     = $facts['os_service_default'],
  $periodic_max_workers                = $facts['os_service_default'],
  $conductor_group                     = $facts['os_service_default'],
  $deploy_kernel                       = $facts['os_service_default'],
  $deploy_ramdisk                      = $facts['os_service_default'],
  $deploy_kernel_by_arch               = $facts['os_service_default'],
  $deploy_ramdisk_by_arch              = $facts['os_service_default'],
  $rescue_kernel                       = $facts['os_service_default'],
  $rescue_ramdisk                      = $facts['os_service_default'],
  $rescue_kernel_by_arch               = $facts['os_service_default'],
  $rescue_ramdisk_by_arch              = $facts['os_service_default'],
  $bootloader                          = $facts['os_service_default'],
  $allow_provisioning_in_maintenance   = $facts['os_service_default'],
  $image_download_concurrency          = $facts['os_service_default'],
  $deploy_callback_timeout             = $facts['os_service_default'],
  $heartbeat_interval                  = $facts['os_service_default'],
  $heartbeat_timeout                   = $facts['os_service_default'],
  $max_concurrent_deploy               = $facts['os_service_default'],
  $max_concurrent_clean                = $facts['os_service_default'],
) {

  include ironic::deps
  include ironic::params

  # For backward compatibility
  include ironic::glance

  # NOTE(dtantsur): all in-tree drivers are IPA-based, so it won't hurt
  # including its manifest (which only contains configuration options)
  include ironic::drivers::agent

  case $cleaning_disk_erase {
    'full': {
      $erase_devices_priority          = 10
      $erase_devices_metadata_priority = 0
    }
    'metadata': {
      $erase_devices_priority          = 0
      $erase_devices_metadata_priority = 10
    }
    'none': {
      $erase_devices_priority          = 0
      $erase_devices_metadata_priority = 0
    }
    default: {
      $erase_devices_priority          = $facts['os_service_default']
      $erase_devices_metadata_priority = $facts['os_service_default']
    }
  }

  include ironic::pxe::common
  $http_root_real = pick($::ironic::pxe::common::http_root, $http_root)

  $deploy_kernel_by_arch_real = $deploy_kernel_by_arch ? {
    Hash    => join(join_keys_to_values($deploy_kernel_by_arch, ':'), ','),
    default => join(any2array($deploy_kernel_by_arch), ','),
  }
  $deploy_ramdisk_by_arch_real = $deploy_ramdisk_by_arch ? {
    Hash    => join(join_keys_to_values($deploy_ramdisk_by_arch, ':'), ','),
    default => join(any2array($deploy_ramdisk_by_arch), ','),
  }
  $rescue_kernel_by_arch_real = $rescue_kernel_by_arch ? {
    Hash    => join(join_keys_to_values($rescue_kernel_by_arch, ':'), ','),
    default => join(any2array($rescue_kernel_by_arch), ','),
  }
  $rescue_ramdisk_by_arch_real = $rescue_ramdisk_by_arch ? {
    Hash    => join(join_keys_to_values($rescue_ramdisk_by_arch, ':'), ','),
    default => join(any2array($rescue_ramdisk_by_arch), ','),
  }

  # Configure ironic.conf
  ironic_config {
    'DEFAULT/enabled_hardware_types':              value => join(any2array($enabled_hardware_types), ',');
    'conductor/force_power_state_during_sync':     value => $force_power_state_during_sync;
    'conductor/automated_clean':                   value => $automated_clean;
    'deploy/http_url':                             value => $http_url;
    'deploy/http_root':                            value => $http_root_real;
    'DEFAULT/force_raw_images':                    value => $force_raw_images;
    'deploy/erase_devices_priority':               value => $erase_devices_priority;
    'deploy/erase_devices_metadata_priority':      value => $erase_devices_metadata_priority;
    'deploy/continue_if_disk_secure_erase_fails':  value => $continue_if_disk_secure_erase_fails;
    'deploy/configdrive_use_object_store':         value => $configdrive_use_object_store;
    'conductor/configdrive_swift_container':       value => $configdrive_swift_container;
    'conductor/inspect_wait_timeout':              value => $inspect_wait_timeout;
    'deploy/default_boot_option':                  value => $default_boot_option;
    'deploy/default_boot_mode':                    value => $default_boot_mode;
    'neutron/port_setup_delay':                    value => $port_setup_delay;
    'conductor/soft_power_off_timeout':            value => $soft_power_off_timeout;
    'conductor/power_state_change_timeout':        value => $power_state_change_timeout;
    'conductor/sync_power_state_interval':         value => $sync_power_state_interval;
    'conductor/sync_power_state_workers':          value => $sync_power_state_workers;
    'conductor/power_state_sync_max_retries':      value => $power_state_sync_max_retries;
    'conductor/power_failure_recovery_interval':   value => $power_failure_recovery_interval;
    'conductor/periodic_max_workers':              value => $periodic_max_workers;
    'conductor/conductor_group':                   value => $conductor_group;
    'conductor/deploy_kernel':                     value => $deploy_kernel;
    'conductor/deploy_ramdisk':                    value => $deploy_ramdisk;
    'conductor/deploy_kernel_by_arch':             value => $deploy_kernel_by_arch_real;
    'conductor/deploy_ramdisk_by_arch':            value => $deploy_ramdisk_by_arch_real;
    'conductor/rescue_kernel':                     value => $rescue_kernel;
    'conductor/rescue_ramdisk':                    value => $rescue_ramdisk;
    'conductor/rescue_kernel_by_arch':             value => $rescue_kernel_by_arch_real;
    'conductor/rescue_ramdisk_by_arch':            value => $rescue_ramdisk_by_arch_real;
    'conductor/bootloader':                        value => $bootloader;
    'conductor/allow_provisioning_in_maintenance': value => $allow_provisioning_in_maintenance;
    'DEFAULT/image_download_concurrency':          value => $image_download_concurrency;
    'conductor/deploy_callback_timeout':           value => $deploy_callback_timeout;
    'conductor/heartbeat_interval':                value => $heartbeat_interval;
    'conductor/heartbeat_timeout':                 value => $heartbeat_timeout;
    'conductor/max_concurrent_deploy':             value => $max_concurrent_deploy;
    'conductor/max_concurrent_clean':              value => $max_concurrent_clean;
  }

  ironic_config {
    'neutron/cleaning_network':     value => $cleaning_network;
    'neutron/provisioning_network': value => $provisioning_network;
    'neutron/rescuing_network':     value => $rescuing_network;
    'neutron/inspection_network':   value => $inspection_network;
  }

  # Install package
  package { 'ironic-conductor':
    ensure => $package_ensure,
    name   => $::ironic::params::conductor_package,
    tag    => ['openstack', 'ironic-package'],
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }

    # Manage service
    service { 'ironic-conductor':
      ensure    => $ensure,
      name      => $::ironic::params::conductor_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'ironic-service',
    }
  }
}
