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
# == Class: ironic::nova
#
# [*auth_type*]
#   The authentication plugin to use when connecting to nova.
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
#   The admin username for ironic to connect to nova.
#   Defaults to 'ironic'.
#
# [*password*]
#   The admin password for ironic to connect to nova.
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
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to $::os_service_default
#
# [*region_name*]
#   (optional) Region name for connecting to nova in admin context
#   through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*endpoint_override*]
#   The endpoint URL for requests for this client
#   Defaults to $::os_service_default
#
# [*send_power_notifications*]
#   Enable the support for power state change callbacks to nova.
#   Defaults to $::os_service_default
#
class ironic::nova (
  $auth_type                = 'password',
  $auth_url                 = $::os_service_default,
  $project_name             = 'services',
  $username                 = 'ironic',
  $password                 = $::os_service_default,
  $user_domain_name         = 'Default',
  $project_domain_name      = 'Default',
  $system_scope             = $::os_service_default,
  $region_name              = $::os_service_default,
  $endpoint_override        = $::os_service_default,
  $send_power_notifications = $::os_service_default,
) {

  include ironic::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $::os_service_default
    $project_domain_name_real = $::os_service_default
  }

  ironic_config {
    'nova/auth_type':                value => $auth_type;
    'nova/username':                 value => $username;
    'nova/password':                 value => $password, secret => true;
    'nova/auth_url':                 value => $auth_url;
    'nova/project_name':             value => $project_name_real;
    'nova/user_domain_name':         value => $user_domain_name;
    'nova/project_domain_name':      value => $project_domain_name_real;
    'nova/system_scope':             value => $system_scope;
    'nova/region_name':              value => $region_name;
    'nova/endpoint_override':        value => $endpoint_override;
    'nova/send_power_notifications': value => $send_power_notifications;
  }
}
