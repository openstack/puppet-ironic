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
#   Defaults to $::os_service_default
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
#   (optional) Region name for connecting to swift in admin context
#   through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*endpoint_override*]
#   The endpoint URL for requests for this client
#   Defaults to $::os_service_default
#
# [*container*]
#    (optional) Default Swift container name to use when creating objects.
#    String value
#    Defaults to $::os_service_default
#
class ironic::inspector::swift (
  $auth_type           = 'password',
  $auth_url            = $::os_service_default,
  $project_name        = 'services',
  $username            = 'ironic',
  $password            = $::os_service_default,
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $region_name         = $::os_service_default,
  $endpoint_override   = $::os_service_default,
  $container           = $::os_service_default,
) {

  $auth_type_real           = pick($::ironic::inspector::swift_auth_type, $auth_type)
  $auth_url_real            = pick($::ironic::inspector::swift_auth_url, $auth_url)
  $username_real            = pick($::ironic::inspector::swift_username, $username)
  $password_real            = pick($::ironic::inspector::swift_password, $password)
  $project_name_real        = pick($::ironic::inspector::swift_tenant_name, $project_name)
  $user_domain_name_real    = pick($::ironic::inspector::swift_user_domain_name, $user_domain_name)
  $project_domain_name_real = pick($::ironic::inspector::swift_project_domain_name, $project_domain_name)
  $region_name_real         = pick($::ironic::inspector::swift_region_name, $region_name)
  $container_real           = pick($::ironic::inspector::swift_container, $container)

  ironic_inspector_config {
    'swift/auth_type':           value => $auth_type_real;
    'swift/username':            value => $username_real;
    'swift/password':            value => $password_real, secret => true;
    'swift/auth_url':            value => $auth_url_real;
    'swift/project_name':        value => $project_name_real;
    'swift/user_domain_name':    value => $user_domain_name_real;
    'swift/project_domain_name': value => $project_domain_name_real;
    'swift/region_name':         value => $region_name_real;
    'swift/endpoint_override':   value => $endpoint_override;
    'swift/container':           value => $container_real;
  }
}
