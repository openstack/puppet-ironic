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
# [*password*]
#   (Optional) The admin password for ironic to connect to ironic-inspector.
#
# [*auth_type*]
#   (Optional) The authentication plugin to use when connecting to
#   ironic-inspector.
#   Defaults to 'password'
#
# [*auth_url*]
#   (Optional) The address of the keystone api endpoint.
#   Defaults to 'http://127.0.0.1:5000'
#
# [*project_name*]
#   (Optional) The Keystone project name.
#   Defaults to 'services'
#
# [*username*]
#   (Optional) The admin username for ironic to connect to ironic-inspector.
#   Defaults to 'ironic'.
#
# [*user_domain_name*]
#   (Optional) The name of user's domain.
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (Optional) The name of project's domain.
#   Defaults to 'Default'
#
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to $facts['os_service_default']
#
# [*region_name*]
#   (Optional) Region name for connecting to ironic-inspector in admin context
#   through the OpenStack Identity service.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_override*]
#   (Optional) The endpoint URL for requests for this client
#   Defaults to $facts['os_service_default']
#
# [*callback_endpoint_override*]
#   (Optional) The endpoint URL to use for ramdisk callback in case of managed
#   boot.
#   Defaults to $facts['os_service_default']
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
  $password                       = undef,
  $auth_type                      = undef,
  $auth_url                       = 'http://127.0.0.1:5000',
  $project_name                   = 'services',
  $username                       = 'ironic',
  $user_domain_name               = 'Default',
  $project_domain_name            = 'Default',
  $system_scope                   = $facts['os_service_default'],
  $region_name                    = $facts['os_service_default'],
  $endpoint_override              = $facts['os_service_default'],
  $callback_endpoint_override     = $facts['os_service_default'],
  $power_off                      = $facts['os_service_default'],
  $extra_kernel_params            = $facts['os_service_default'],
  $require_managed_boot           = $facts['os_service_default'],
  $add_ports                      = $facts['os_service_default'],
  $keep_ports                     = $facts['os_service_default'],
  $additional_hooks               = undef,
  Hash $physical_network_cidr_map = {},
) {
  include ironic::deps

  if $auth_type {
    if $password == undef {
      fail('The password parameter is required to use ironic-inspector')
    }
    $auth_type_real = $auth_type
    $password_real = $password
  } elsif $password {
    $auth_type_real = 'password'
    $password_real = $password
  } else {
    $auth_type_real = $facts['os_service_default']
    $password_real = $facts['os_service_default']
  }

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  $hooks = $additional_hooks ? {
    undef   => $facts['os_service_default'],
    default => join(concat(['$default_hooks'], any2array($additional_hooks)), ',')
  }
  $physical_network_cidr_map_real = empty($physical_network_cidr_map) ? {
    true    => $facts['os_service_default'],
    default => join(join_keys_to_values($physical_network_cidr_map, ':'), ',')
  }

  ironic_config {
    'inspector/auth_type':                  value => $auth_type_real;
    'inspector/username':                   value => $username;
    'inspector/password':                   value => $password_real, secret => true;
    'inspector/auth_url':                   value => $auth_url;
    'inspector/project_name':               value => $project_name_real;
    'inspector/user_domain_name':           value => $user_domain_name;
    'inspector/project_domain_name':        value => $project_domain_name_real;
    'inspector/system_scope':               value => $system_scope;
    'inspector/region_name':                value => $region_name;
    'inspector/endpoint_override':          value => $endpoint_override;
    'inspector/callback_endpoint_override': value => $callback_endpoint_override;
    'inspector/power_off':                  value => $power_off;
    'inspector/extra_kernel_params':        value => $extra_kernel_params;
    'inspector/require_managed_boot':       value => $require_managed_boot;
    'inspector/add_ports':                  value => $add_ports;
    'inspector/keep_ports':                 value => $keep_ports;
    'inspector/hooks':                      value => $hooks;
    'inspector/physical_network_cidr_map':  value => $physical_network_cidr_map_real;
  }
}
