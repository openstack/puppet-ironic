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
#   (optional) Control the ensure parameter for the package ressource.
#   Defaults to 'present'.
#
# [*enabled*]
#   (optional) Define if the service must be enabled or not.
#   Defaults to true.
#
# [*enabled_drivers*]
#  (optional) Array of drivers to load during service initialization.
#  Defaults to ['pxe_ipmitool'].
#
# [*enabled_hardware_types*]
#  (optional) Array of hardware types to load during service initialization.
#  Defaults to ['ipmi'].
#
# [*max_time_interval*]
#   (optional) Maximum time, in seconds, since the last check-in of a conductor.
#   Should be an interger value
#   Defaults to '120'.
#
# [*force_power_state_during_sync*]
#   (optional) Should the hardware power state be set to the state recorded in
#   the database (True) or should the database be updated based on the hardware
#   state (False).
#   Defaults to true.
#
# [*http_url*]
#   (optional) ironic-conductor node's HTTP server URL.
#   Defaults to $::os_service_default
#
# [*http_root*]
#   (optional) ironic-conductor node's HTTP root path.
#   Defaults to $::os_service_default
#
# [*automated_clean*]
#   (optional) Whether to enable automated cleaning on nodes.
#   Defaults to $::os_service_default
#
# [*cleaning_network*]
#   (optional) UUID or name of the network to create Neutron ports on, when
#   booting to a ramdisk for cleaning using Neutron DHCP.
#   Can not be specified together with cleaning_network_name.
#   Defaults to $::os_service_default
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
#   Defaults to $::os_service_default
#
# [*api_url*]
#   (optional) Ironic API URL.
#   Defaults to $::os_service_default
#
# [*provisioning_network*]
#   (optional) Neutron network UUID or name for the ramdisk to be booted into
#   for provisioning nodes. Required for neutron network interface.
#   Can not be specified together with provisioning_network_name.
#   Defaults to $::os_service_default
#
# [*configdrive_use_swift*]
#   (optional) Whether to use Swift for storing config drives instead of
#   the database. Recommended for bigger config drives.
#   Defaults to $::os_service_default
#
# [*configdrive_swift_container*]
#   (optinal) Swift container to use for storing config drives if
#   configdrive_use_swift is true.
#   Defaults to $::os_service_default
#
# [*default_boot_option*]
#   (optional) Default boot option to use when no boot option is explicitly
#   requested. One of "netboot" or "local".
#   Defaults to $::os_service_default
#
# [*cleaning_network_name*]
#   (optional) If provided the name will be converted to UUID and set
#   as value of neutron/cleaning_network option in ironic.conf
#   Can not be specified together with cleaning_network.
#   Defaults to undef, which leaves the configuration intact
#
# [*provisioning_network_name*]
#   (optional) If provided the name will be converted to UUID and set
#   as value of neutron/provisioning_network option in ironic.conf
#   Can not be specified together with provisioning_network.
#   Defaults to undef, which leaves the configuration intact
#
# [*port_setup_delay*]
#   (optional) Delay value to wait for Neutron agents to setup
#   sufficient DHCP configuration for port.
#   Defaults to $::os_service_default
#
# DEPRECATED
#
# [*cleaning_network_uuid*]
#   (optional) Use cleaning_network instead.
#   Defaults to undef
#
# [*provisioning_network_uuid*]
#   (optional) Use provisioning_network instead.
#   Defaults to undef
#
# [*swift_account*]
#   (optional) The account that Glance uses to communicate with Swift.
#   The format is "AUTH_uuid"
#   Defaults to $::os_service_default
#
# [*swift_temp_url_key*]
#   (optional) The secret token given to Swift to allow temporary URL
#   downloads. Required for several drivers (e.g. agent_ipmitool).
#   Defaults to $::os_service_default
#
# [*swift_temp_url_duration*]
#   (optional) The length of time in seconds that the temporary URL will be
#   valid for.
#   Defaults to $::os_service_default
#
class ironic::conductor (
  $package_ensure                      = 'present',
  $enabled                             = true,
  $enabled_drivers                     = ['pxe_ipmitool'],
  $enabled_hardware_types              = ['ipmi'],
  $max_time_interval                   = '120',
  $force_power_state_during_sync       = true,
  $http_url                            = $::os_service_default,
  $http_root                           = $::os_service_default,
  $automated_clean                     = $::os_service_default,
  $cleaning_network                    = $::os_service_default,
  $cleaning_disk_erase                 = undef,
  $continue_if_disk_secure_erase_fails = $::os_service_default,
  $api_url                             = $::os_service_default,
  $provisioning_network                = $::os_service_default,
  $configdrive_use_swift               = $::os_service_default,
  $configdrive_swift_container         = $::os_service_default,
  $default_boot_option                 = $::os_service_default,
  $port_setup_delay                    = $::os_service_default,
  $cleaning_network_name               = undef,
  $provisioning_network_name           = undef,
  # DEPRECATED
  $cleaning_network_uuid               = undef,
  $provisioning_network_uuid           = undef,
  $swift_account                       = undef,
  $swift_temp_url_key                  = undef,
  $swift_temp_url_duration             = undef,
) {

  include ::ironic::deps
  include ::ironic::params

  # For backward compatibility
  include ::ironic::glance

  if $cleaning_network_uuid {
    warning('cleaning_network_uuid is deprecated, use cleaning_network')
  }
  if $provisioning_network_uuid {
    warning('provisioning_network_uuid is deprecated, use provisioning_network')
  }
  $cleaning_network_real = pick($cleaning_network_uuid, $cleaning_network)
  $provisioning_network_real = pick($provisioning_network_uuid, $provisioning_network)

  if ($cleaning_network_name and !is_service_default($cleaning_network_real)) {
    fail("cleaning_network_name and cleaning_network or cleaning_network_uuid can not be \
specified in the same time.")
  }

  if ($provisioning_network_name and !is_service_default($provisioning_network_real)) {
    fail("provisioning_network_name and provisioning_network or provisioning_network_uuid can not be \
specified in the same time.")
  }

  if $swift_account or $swift_temp_url_key or $swift_temp_url_duration {
    warning("swift_account, swift_temp_url_key and swift_temp_url_duration were \
moved to ironic::glance manifest")
  }

  validate_array($enabled_drivers)
  validate_array($enabled_hardware_types)

  # NOTE(dtantsur): all in-tree drivers are IPA-based, so it won't hurt
  # including its manifest (which only contains configuration options)
  include ::ironic::drivers::agent

  # On Ubuntu, ipmitool dependency is missing and ironic-conductor fails to start.
  # https://bugs.launchpad.net/cloud-archive/+bug/1572800
  if (member($enabled_drivers, 'pxe_ipmitool') or
      member($enabled_hardware_types, 'ipmi')) and $::osfamily == 'Debian' {
    ensure_packages('ipmitool',
      {
        ensure => $package_ensure,
        tag    => ['openstack', 'ironic-package'],
      }
    )
  }

  if $cleaning_disk_erase {
    validate_re($cleaning_disk_erase, ['^full$', '^metadata$', '^none$'])
  }

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
      $erase_devices_priority          = $::os_service_default
      $erase_devices_metadata_priority = $::os_service_default
    }
  }

  # Configure ironic.conf
  ironic_config {
    'DEFAULT/enabled_drivers':                    value => join($enabled_drivers, ',');
    'DEFAULT/enabled_hardware_types':             value => join($enabled_hardware_types, ',');
    'conductor/max_time_interval':                value => $max_time_interval;
    'conductor/force_power_state_during_sync':    value => $force_power_state_during_sync;
    'conductor/automated_clean':                  value => $automated_clean;
    'conductor/api_url':                          value => $api_url;
    'deploy/http_url':                            value => $http_url;
    'deploy/http_root':                           value => $http_root;
    'deploy/erase_devices_priority':              value => $erase_devices_priority;
    'deploy/erase_devices_metadata_priority':     value => $erase_devices_metadata_priority;
    'deploy/continue_if_disk_secure_erase_fails': value => $continue_if_disk_secure_erase_fails;
    'conductor/configdrive_use_swift':            value => $configdrive_use_swift;
    'conductor/configdrive_swift_container':      value => $configdrive_swift_container;
    'deploy/default_boot_option':                 value => $default_boot_option;
    'neutron/port_setup_delay':                   value => $port_setup_delay;
  }

  if $cleaning_network_name {
    ironic_config {
      'neutron/cleaning_network': value => $cleaning_network_name, transform_to => 'net_uuid';
    }
  } else {
    ironic_config {
      'neutron/cleaning_network': value => $cleaning_network_real;
    }
  }

  if $provisioning_network_name {
    ironic_config {
      'neutron/provisioning_network': value => $provisioning_network_name, transform_to => 'net_uuid';
    }
  } else {
    ironic_config {
      'neutron/provisioning_network': value => $provisioning_network_real;
    }
  }

  # Install package
  if $::ironic::params::conductor_package {
    package { 'ironic-conductor':
      ensure => $package_ensure,
      name   => $::ironic::params::conductor_package,
      tag    => ['openstack', 'ironic-package'],
    }
  }

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
