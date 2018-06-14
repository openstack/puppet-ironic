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

# Configure the interfaces in Ironic
#
# === Parameters
#
# [*default_bios_interface*]
#   (optional) Default bios interface to be used for nodes that do not have
#   bios_interface field set.
#   Defaults to $::os_service_default
#
# [*default_boot_interface*]
#   (optional) Default boot interface to be used for nodes that do not have
#   boot_interface field set.
#   Defaults to $::os_service_default
#
# [*default_console_interface*]
#   (optional) Default console interface to be used for nodes that do not have
#   console_interface field set.
#   Defaults to $::os_service_default
#
# [*default_deploy_interface*]
#   (optional) Default deploy interface to be used for nodes that do not have
#   deploy_interface field set.
#   Defaults to $::os_service_default
#
# [*default_inspect_interface*]
#   (optional) Default inspect interface to be used for nodes that do not have
#   inspect_interface field set.
#   Defaults to $::os_service_default
#
# [*default_management_interface*]
#   (optional) Default management interface to be used for nodes that do not have
#   management_interface field set.
#   Defaults to $::os_service_default
#
# [*default_network_interface*]
#   (optional) Default network interface to be used for nodes that do not have
#   network_interface field set.
#   Defaults to $::os_service_default
#
# [*default_power_interface*]
#   (optional) Default power interface to be used for nodes that do not have
#   power_interface field set.
#   Defaults to $::os_service_default
#
# [*default_raid_interface*]
#   (optional) Default raid interface to be used for nodes that do not have
#   raid_interface field set.
#   Defaults to $::os_service_default
#
# [*default_rescue_interface*]
#   (optional) Default rescue interface to be used for nodes that do not have
#   rescue_interface field set.
#   Defaults to $::os_service_default
#
# [*default_storage_interface*]
#   (optional) Default storage interface to be used for nodes that do not have
#   storage_interface field set.
#   Defaults to $::os_service_default
#
# [*default_vendor_interface*]
#   (optional) Default vendor interface to be used for nodes that do not have
#   vendor_interface field set.
#   Defaults to $::os_service_default
#
# [*enabled_bios_interfaces*]
#   (optional) Specify the list of bios interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_boot_interfaces*]
#   (optional) Specify the list of boot interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_console_interfaces*]
#   (optional) Specify the list of console interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_deploy_interfaces*]
#   (optional) Specify the list of deploy interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_inspect_interfaces*]
#   (optional) Specify the list of inspect interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_management_interfaces*]
#   (optional) Specify the list of management interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_network_interfaces*]
#   (optional) Specify the list of network interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_power_interfaces*]
#   (optional) Specify the list of power interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_raid_interfaces*]
#   (optional) Specify the list of raid interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_rescue_interfaces*]
#   (optional) Specify the list of rescue interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_storage_interfaces*]
#   (optional) Specify the list of storage interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
# [*enabled_vendor_interfaces*]
#   (optional) Specify the list of vendor interfaces to load during
#   service initialization.
#   Defaults to $::os_service_default
#
class ironic::drivers::interfaces (
  $default_bios_interface        = $::os_service_default,
  $default_boot_interface        = $::os_service_default,
  $default_console_interface     = $::os_service_default,
  $default_deploy_interface      = $::os_service_default,
  $default_inspect_interface     = $::os_service_default,
  $default_management_interface  = $::os_service_default,
  $default_network_interface     = $::os_service_default,
  $default_power_interface       = $::os_service_default,
  $default_raid_interface        = $::os_service_default,
  $default_rescue_interface      = $::os_service_default,
  $default_storage_interface     = $::os_service_default,
  $default_vendor_interface      = $::os_service_default,
  $enabled_bios_interfaces       = $::os_service_default,
  $enabled_boot_interfaces       = $::os_service_default,
  $enabled_console_interfaces    = $::os_service_default,
  $enabled_deploy_interfaces     = $::os_service_default,
  $enabled_inspect_interfaces    = $::os_service_default,
  $enabled_management_interfaces = $::os_service_default,
  $enabled_network_interfaces    = $::os_service_default,
  $enabled_power_interfaces      = $::os_service_default,
  $enabled_raid_interfaces       = $::os_service_default,
  $enabled_rescue_interfaces     = $::os_service_default,
  $enabled_storage_interfaces    = $::os_service_default,
  $enabled_vendor_interfaces     = $::os_service_default,
) {

  $interfaces = {
    'bios'       => { 'enabled_list' => $enabled_bios_interfaces,
                      'default'      => $default_bios_interface },
    'boot'       => { 'enabled_list' => $enabled_boot_interfaces,
                      'default'      => $default_boot_interface },
    'console'    => { 'enabled_list' => $enabled_console_interfaces,
                      'default'      => $default_console_interface },
    'deploy'     => { 'enabled_list' => $enabled_deploy_interfaces,
                      'default'      => $default_deploy_interface },
    'inspect'    => { 'enabled_list' => $enabled_inspect_interfaces,
                      'default'      => $default_inspect_interface },
    'management' => { 'enabled_list' => $enabled_management_interfaces,
                      'default'      => $default_management_interface },
    'network'    => { 'enabled_list' => $enabled_network_interfaces,
                      'default'      => $default_network_interface },
    'power'      => { 'enabled_list' => $enabled_power_interfaces,
                      'default'      => $default_power_interface },
    'raid'       => { 'enabled_list' => $enabled_raid_interfaces,
                      'default'      => $default_raid_interface },
    'rescue'     => { 'enabled_list' => $enabled_rescue_interfaces,
                      'default'      => $default_rescue_interface },
    'storage'    => { 'enabled_list' => $enabled_storage_interfaces,
                      'default'      => $default_storage_interface },
    'vendor'     => { 'enabled_list' => $enabled_vendor_interfaces,
                      'default'      => $default_vendor_interface },
  }

  create_resources(ironic::drivers::hardware_interface, $interfaces)
}
