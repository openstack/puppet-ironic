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
# [*swift_account*]
#   (optional) The account that Glance uses to communicate with Swift.
#   The format is "AUTH_uuid"
#   Defaults to $::os_service_default
#
# [*cleaning_network_uuid*]
#   (optional) UUID of the network to create Neutron ports on, when booting
#   to a ramdisk for cleaning using Neutron DHCP.
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
# [*provisioning_network_uuid*]
#   (optional) Neutron network UUID for the ramdisk to be booted into for
#    provisioning nodes. Required for neutron network interface.
#    Defaults to $::os_service_default
#
class ironic::conductor (
  $package_ensure                       = 'present',
  $enabled                              = true,
  $max_time_interval                    = '120',
  $force_power_state_during_sync        = true,
  $http_url                             = $::os_service_default,
  $http_root                            = $::os_service_default,
  $automated_clean                      = $::os_service_default,
  $swift_account                        = $::os_service_default,
  $cleaning_network_uuid                = $::os_service_default,
  $cleaning_disk_erase                  = undef,
  $continue_if_disk_secure_erase_fails  = $::os_service_default,
  $api_url                              = $::os_service_default,
  $provisioning_network_uuid            = $::os_service_default,
) {

  include ::ironic::params
  include ::ironic::drivers::deploy

  Ironic_config<||> ~> Service['ironic-conductor']

  if $cleaning_disk_erase {
    validate_re($cleaning_disk_erase, ['^full$', '^metadata$', '^none$'])
  }

  case $cleaning_disk_erase {
    'full': {
      $erase_devices_priority = 10
      $erase_devices_metadata_priority = 0
    }
    'metadata': {
      $erase_devices_priority = 0
      $erase_devices_metadata_priority = 10
    }
    'none': {
      $erase_devices_priority = 0
      $erase_devices_metadata_priority = 0
    }
    default: {
      $erase_devices_priority = $::os_service_default
      $erase_devices_metadata_priority = $::os_service_default
    }
  }

  $http_url_real = pick($::ironic::drivers::deploy::http_url, $http_url)
  $http_root_real = pick($::ironic::drivers::deploy::http_root, $http_root)

  # Configure ironic.conf
  ironic_config {
    'conductor/max_time_interval': value => $max_time_interval;
    'conductor/force_power_state_during_sync': value => $force_power_state_during_sync;
    'conductor/automated_clean': value => $automated_clean;
    'conductor/api_url': value => $api_url;
    'glance/swift_account': value => $swift_account;
    'neutron/cleaning_network_uuid': value => $cleaning_network_uuid;
    'neutron/provisioning_network_uuid': value => $provisioning_network_uuid;
    'deploy/http_url':  value => $http_url_real;
    'deploy/http_root': value => $http_root_real;
    'deploy/erase_devices_priority': value => $erase_devices_priority;
    'deploy/erase_devices_metadata_priority': value => $erase_devices_metadata_priority;
    'deploy/continue_if_disk_secure_erase_fails': value => $continue_if_disk_secure_erase_fails;
  }

  # Install package
  if $::ironic::params::conductor_package {
    Package<| tag == 'ironic-package' |> -> Service['ironic-conductor']
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
