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
# == Class: ironic::neutron
#
# [*auth_type*]
#   The authentication plugin to use when connecting to neutron.
#   Defaults to 'password'
#
# [*auth_url*]
#   The address of the keystone api endpoint.
#   Defaults to $::os_service_default
#
# [*project_name*]
#   The Keystone project name.
#   Defaults to 'services'
#
# [*username*]
#   The admin username for ironic to connect to neutron.
#   Defaults to 'ironic'.
#
# [*password*]
#   The admin password for ironic to connect to neutron.
#   Defaults to $::os_service_default
#
# [*user_domain_name*]
#   The name of user's domain (required for Identity V3).
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   The name of project's domain (required for Identity V3).
#   Defaults to 'Default'
#
# [*region_name*]
#   (optional) Region name for connecting to neutron in admin context
#   through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*endpoint_override*]
#   The endpoint URL for requests for this client
#   Defaults to $::os_service_default
#
# [*dhcpv6_stateful_address_count*]
#   Number of IPv6 addresses to allocate for ports created for provisioning,
#   cleaning, rescue or inspection on DHCPv6-stateful networks. Different stages
#   of the chain-loading process will request addresses with different
#   CLID/IAID. Due to non-identical identifiers multiple addresses must be
#   reserved for the host to ensure each step of the boot process can
#   successfully lease addresses.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*api_endpoint*]
#   Has no effect, use endpoint_override.
#   Defaults to undef
#
class ironic::neutron (
  $auth_type                     = 'password',
  $auth_url                      = $::os_service_default,
  $project_name                  = 'services',
  $username                      = 'ironic',
  $password                      = $::os_service_default,
  $user_domain_name              = 'Default',
  $project_domain_name           = 'Default',
  $region_name                   = $::os_service_default,
  $endpoint_override             = $::os_service_default,
  $dhcpv6_stateful_address_count = $::os_service_default,
  # DEPRECATED PARAMETERS
  $api_endpoint                  = undef,
) {

  if $api_endpoint {
    warning("The ironic::neutron::api_endpoint parameter is deprecated and \
has no effect. Please use ironic::neutron::endpoint_override instead.")
  }

  ironic_config {
    'neutron/auth_type':                     value => $auth_type;
    'neutron/username':                      value => $username;
    'neutron/password':                      value => $password, secret => true;
    'neutron/auth_url':                      value => $auth_url;
    'neutron/project_name':                  value => $project_name;
    'neutron/user_domain_name':              value => $user_domain_name;
    'neutron/project_domain_name':           value => $project_domain_name;
    'neutron/region_name':                   value => $region_name;
    'neutron/endpoint_override':             value => $endpoint_override;
    'neutron/dhcpv6_stateful_address_count': value => $dhcpv6_stateful_address_count;
  }
}
