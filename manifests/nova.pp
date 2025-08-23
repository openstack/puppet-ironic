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
# [*password*]
#   (Optional) The admin password for ironic to connect to nova.
#   This is required when send_power_notifications is true.
#   Defaults to undef
#
# [*auth_type*]
#   (Optional) The authentication plugin to use when connecting to nova.
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
#   (Optional) The admin username for ironic to connect to nova.
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
#   (Optional) Region name for connecting to nova in admin context
#   through the OpenStack Identity service.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_override*]
#   (Optional) The endpoint URL for requests for this client
#   Defaults to $facts['os_service_default']
#
# [*send_power_notifications*]
#   (Optional) Enable the support for power state change callbacks to nova.
#   Defaults to true
#
class ironic::nova (
  $password                         = undef,
  $auth_type                        = 'password',
  $auth_url                         = 'http://127.0.0.1:5000',
  $project_name                     = 'services',
  $username                         = 'ironic',
  $user_domain_name                 = 'Default',
  $project_domain_name              = 'Default',
  $system_scope                     = $facts['os_service_default'],
  $region_name                      = $facts['os_service_default'],
  $endpoint_override                = $facts['os_service_default'],
  Boolean $send_power_notifications = true,
) {
  include ironic::deps

  ironic_config {
    'nova/send_power_notifications': value => $send_power_notifications;
  }

  if $send_power_notifications {
    if password == undef {
      fail('The password parameter is required when send_power_notifications is true')
    }

    if is_service_default($system_scope) {
      $project_name_real = $project_name
      $project_domain_name_real = $project_domain_name
    } else {
      $project_name_real = $facts['os_service_default']
      $project_domain_name_real = $facts['os_service_default']
    }

    ironic_config {
      'nova/auth_type':           value => $auth_type;
      'nova/username':            value => $username;
      'nova/password':            value => $password, secret => true;
      'nova/auth_url':            value => $auth_url;
      'nova/project_name':        value => $project_name_real;
      'nova/user_domain_name':    value => $user_domain_name;
      'nova/project_domain_name': value => $project_domain_name_real;
      'nova/system_scope':        value => $system_scope;
      'nova/region_name':         value => $region_name;
      'nova/endpoint_override':   value => $endpoint_override;
    }
  } else {
    ironic_config {
      'nova/auth_type':           ensure => absent;
      'nova/username':            ensure => absent;
      'nova/password':            ensure => absent;
      'nova/auth_url':            ensure => absent;
      'nova/project_name':        ensure => absent;
      'nova/user_domain_name':    ensure => absent;
      'nova/project_domain_name': ensure => absent;
      'nova/system_scope':        ensure => absent;
      'nova/region_name':         ensure => absent;
      'nova/endpoint_override':   ensure => absent;
    }
  }
}
