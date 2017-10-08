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
# == Class: ironic::swift
#
# [*auth_type*]
#   The authentication plugin to use when connecting to swift.
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
#   The admin username for ironic to connect to swift.
#   Defaults to 'ironic'.
#
# [*password*]
#   The admin password for ironic to connect to swift.
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
class ironic::swift (
  $auth_type           = 'password',
  $auth_url            = $::os_service_default,
  $project_name        = 'services',
  $username            = 'ironic',
  $password            = $::os_service_default,
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
) {

  ironic_config {
    'swift/auth_type':           value => $auth_type;
    'swift/username':            value => $username;
    'swift/password':            value => $password, secret => true;
    'swift/auth_url':            value => $auth_url;
    'swift/project_name':        value => $project_name;
    'swift/user_domain_name':    value => $user_domain_name;
    'swift/project_domain_name': value => $project_domain_name;
  }
}
