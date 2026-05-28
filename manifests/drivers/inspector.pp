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
# == Class: ironic::drivers::inspector
#
# Configure how Ironic talks to Ironic Inspector.
#
# [*power_off*]
#   (Optional) Whether to power off a node after inspection in case of managed
#   boot.
#   Defaults to $facts['os_service_default']
#
# [*extra_kernel_params*]
#   (Optional) Extra kernel parameters to pass in case of managed boot.
#   Defaults to $facts['os_service_default']
#
# [*require_managed_boot*]
#   (Optional) Require that the in-band inspection boot is fully managed by
#   the node's boot interface.
#   Defaults to $facts['os_service_default']
#
# [*add_ports*]
#   (Optional)  Which MAC addresses to add as ports during introspection.
#   Defaults to $facts['os_service_default']
#
# [*keep_ports*]
#   (Optional) Which ports to keep after introspection
#   Defaults to $facts['os_service_default']
#
# [*additional_hooks*]
#   (Optional) List of processing hooks to append to the default list.
#   Defaults to undef
#
# [*physical_network_cidr_map*]
#   (Optional) Mapping of IP subnet CIDR to physical network.
#
class ironic::drivers::inspector (
  $power_off                      = $facts['os_service_default'],
  $extra_kernel_params            = $facts['os_service_default'],
  $require_managed_boot           = $facts['os_service_default'],
  $add_ports                      = $facts['os_service_default'],
  $keep_ports                     = $facts['os_service_default'],
  $additional_hooks               = undef,
  Hash $physical_network_cidr_map = {},
) {
  include ironic::deps

  $hooks = $additional_hooks ? {
    undef   => $facts['os_service_default'],
    default => join(concat(['$default_hooks'], any2array($additional_hooks)), ',')
  }
  $physical_network_cidr_map_real = empty($physical_network_cidr_map) ? {
    true    => $facts['os_service_default'],
    default => join(join_keys_to_values($physical_network_cidr_map, ':'), ',')
  }

  ironic_config {
    'inspector/power_off':                 value => $power_off;
    'inspector/extra_kernel_params':       value => $extra_kernel_params;
    'inspector/require_managed_boot':      value => $require_managed_boot;
    'inspector/add_ports':                 value => $add_ports;
    'inspector/keep_ports':                value => $keep_ports;
    'inspector/hooks':                     value => $hooks;
    'inspector/physical_network_cidr_map': value => $physical_network_cidr_map_real;
  }
}
