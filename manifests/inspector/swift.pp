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
# == Class: ironic::inspector::swift
#
# [*auth_type*]
#   The authentication plugin to use when connecting to swift.
#   Defaults to 'password'
#
# [*auth_url*]
#   The address of the keystone api endpoint.
#   Defaults to $facts['os_service_default']
#
# [*project_name*]
#   The Keystone project name.
#   Defaults to 'services'
#
# [*username*]
#   The admin username for ironic-inspector to connect to swift.
#   Defaults to 'ironic'.
#
# [*password*]
#   The admin password for ironic-inspector to connect to swift.
#   Defaults to $facts['os_service_default']
#
# [*user_domain_name*]
#   The name of user's domain (required for Identity V3).
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   The name of project's domain (required for Identity V3).
#   Defaults to 'Default'
#
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to $facts['os_service_default']
#
# [*region_name*]
#   (optional) Region name for connecting to swift in admin context
#   through the OpenStack Identity service.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_override*]
#   The endpoint URL for requests for this client
#   Defaults to $facts['os_service_default']
#
# [*container*]
#    (optional) Default Swift container name to use when creating objects.
#    String value
#    Defaults to $facts['os_service_default']
#
# [*delete_after*]
#   (optional) Number of seconds that the Swift object will last before being
#   deleted.
#   Defaults to $facts['os_service_default']
#
class ironic::inspector::swift (
  $auth_type           = 'password',
  $auth_url            = $facts['os_service_default'],
  $project_name        = 'services',
  $username            = 'ironic',
  $password            = $facts['os_service_default'],
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $system_scope        = $facts['os_service_default'],
  $region_name         = $facts['os_service_default'],
  $endpoint_override   = $facts['os_service_default'],
  $container           = $facts['os_service_default'],
  $delete_after        = $facts['os_service_default'],
) {

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  ironic_inspector_config {
    'swift/auth_type':           value => $auth_type;
    'swift/username':            value => $username;
    'swift/password':            value => $password, secret => true;
    'swift/auth_url':            value => $auth_url;
    'swift/project_name':        value => $project_name_real;
    'swift/user_domain_name':    value => $user_domain_name;
    'swift/project_domain_name': value => $project_domain_name_real;
    'swift/system_scope':        value => $system_scope;
    'swift/region_name':         value => $region_name;
    'swift/endpoint_override':   value => $endpoint_override;
    'swift/container':           value => $container;
    'swift/delete_after':        value => $delete_after;
  }
}
