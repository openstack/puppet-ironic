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
# DEPRECATED PARAMETERS
#
# [*password*]
#   (Optional) The admin password for ironic to connect to ironic-inspector.
#   Defaults to undef
#
# [*auth_type*]
#   (Optional) The authentication plugin to use when connecting to
#   ironic-inspector.
#   Defaults to undef
#
# [*auth_url*]
#   (Optional) The address of the keystone api endpoint.
#   Defaults to undef
#
# [*project_name*]
#   (Optional) The Keystone project name.
#   Defaults to undef
#
# [*username*]
#   (Optional) The admin username for ironic to connect to ironic-inspector.
#   Defaults to undef
#
# [*user_domain_name*]
#   (Optional) The name of user's domain.
#   Defaults to undef
#
# [*project_domain_name*]
#   (Optional) The name of project's domain.
#   Defaults to undef
#
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to undef
#
# [*region_name*]
#   (Optional) Region name for connecting to ironic-inspector in admin context
#   through the OpenStack Identity service.
#   Defaults to undef
#
# [*endpoint_override*]
#   (Optional) The endpoint URL for requests for this client
#   Defaults to undef
#
# [*callback_endpoint_override*]
#   (Optional) The endpoint URL to use for ramdisk callback in case of managed
#   boot.
#   Defaults to undef
#
class ironic::drivers::inspector (
  $power_off                      = $facts['os_service_default'],
  $extra_kernel_params            = $facts['os_service_default'],
  $require_managed_boot           = $facts['os_service_default'],
  $add_ports                      = $facts['os_service_default'],
  $keep_ports                     = $facts['os_service_default'],
  $additional_hooks               = undef,
  Hash $physical_network_cidr_map = {},
  # DEPRECATED PARAMETERS
  $password                       = undef,
  $auth_type                      = undef,
  $auth_url                       = undef,
  $project_name                   = undef,
  $username                       = undef,
  $user_domain_name               = undef,
  $project_domain_name            = undef,
  $system_scope                   = undef,
  $region_name                    = undef,
  $endpoint_override              = undef,
  $callback_endpoint_override     = undef,
) {
  include ironic::deps

  [
    'password',
    'auth_type',
    'auth_url',
    'project_name',
    'username',
    'user_domain_name',
    'project_domain_name',
    'system_scope',
    'region_name',
    'endpoint_override',
    'callback_endpoint_override',
  ].each |String $deprecated_opt| {
    if getvar($deprecated_opt) != undef {
      warning("The ${deprecated_opt} parameter is deprecated and has no effect.")
    }
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
    'inspector/callback_endpoint_override': value => $callback_endpoint_override;
    'inspector/power_off':                  value => $power_off;
    'inspector/extra_kernel_params':        value => $extra_kernel_params;
    'inspector/require_managed_boot':       value => $require_managed_boot;
    'inspector/add_ports':                  value => $add_ports;
    'inspector/keep_ports':                 value => $keep_ports;
    'inspector/hooks':                      value => $hooks;
    'inspector/physical_network_cidr_map':  value => $physical_network_cidr_map_real;
  }

  ironic_config {
    'inspector/auth_type':           ensure => absent;
    'inspector/username':            ensure => absent;
    'inspector/password':            ensure => absent, secret => true;
    'inspector/auth_url':            ensure => absent;
    'inspector/project_name':        ensure => absent;
    'inspector/user_domain_name':    ensure => absent;
    'inspector/project_domain_name': ensure => absent;
    'inspector/system_scope':        ensure => absent;
    'inspector/region_name':         ensure => absent;
    'inspector/endpoint_override':   ensure => absent;
  }
}
