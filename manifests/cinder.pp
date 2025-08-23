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
# == Class: ironic::cinder
#
# [*password*]
#   (Required) The admin password for ironic to connect to cinder.
#
# [*auth_type*]
#   (Optional) The authentication plugin to use when connecting to cinder.
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
#   (Optional) The admin username for ironic to connect to cinder.
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
#   (Optional) Region name for connecting to cinder in admin context
#   through the OpenStack Identity service.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_override*]
#   (Optional) The endpoint URL for requests for this client
#   Defaults to $facts['os_service_default']
#
class ironic::cinder (
  $password,
  $auth_type           = 'password',
  $auth_url            = 'http://127.0.0.1:5000',
  $project_name        = 'services',
  $username            = 'ironic',
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $system_scope        = $facts['os_service_default'],
  $region_name         = $facts['os_service_default'],
  $endpoint_override   = $facts['os_service_default'],
) {
  include ironic::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  ironic_config {
    'cinder/auth_type':           value => $auth_type;
    'cinder/username':            value => $username;
    'cinder/password':            value => $password, secret => true;
    'cinder/auth_url':            value => $auth_url;
    'cinder/project_name':        value => $project_name_real;
    'cinder/user_domain_name':    value => $user_domain_name;
    'cinder/project_domain_name': value => $project_domain_name_real;
    'cinder/system_scope':        value => $system_scope;
    'cinder/region_name':         value => $region_name;
    'cinder/endpoint_override':   value => $endpoint_override;
  }
}
