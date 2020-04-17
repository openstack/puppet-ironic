# Licensed under the Apache License, Version 2.0 (the "License")_real; you may
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
# == Class: ironic::inspector::ironic
#
# [*auth_type*]
#   The authentication plugin to use when connecting to ironic.
#   Defaults to 'password'
#
# [*auth_url*]
#   The address of the keystone api endpoint.
#   Defaults to 'http://127.0.0.1:5000/v3'
#
# [*project_name*]
#   The Keystone project name.
#   Defaults to 'services'
#
# [*username*]
#   The admin username for ironic-inspector to connect to ironic.
#   Defaults to 'ironic'.
#
# [*password*]
#   The admin password for ironic-inspector to connect to ironic.
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
#   (optional) Region name for connecting to ironic in admin context
#   through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*endpoint_override*]
#   The endpoint URL for requests for this client
#   Defaults to $::os_service_default
#
# [*max_retries*]
#   (optional) Maximum number of retries in case of conflict error
#   Defaults to 30
#
# [*retry_interval*]
#   (optional) Interval between retries in case of conflict error
#   Defaults to 2
#
class ironic::inspector::ironic (
  $auth_type           = 'password',
  $auth_url            = 'http://127.0.0.1:5000/v3',
  $project_name        = 'services',
  $username            = 'ironic',
  $password            = $::os_service_default,
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $region_name         = $::os_service_default,
  $endpoint_override   = $::os_service_default,
  $max_retries         = 30,
  $retry_interval      = 2,
) {

  $auth_type_real           = pick($::ironic::inspector::ironic_auth_type, $auth_type)
  $auth_url_real            = pick($::ironic::inspector::ironic_auth_url, $auth_url)
  $username_real            = pick($::ironic::inspector::ironic_username, $username)
  $password_real            = pick($::ironic::inspector::ironic_password, $password)
  $project_name_real        = pick($::ironic::inspector::ironic_tenant_name, $project_name)
  $user_domain_name_real    = pick($::ironic::inspector::ironic_user_domain_name, $user_domain_name)
  $project_domain_name_real = pick($::ironic::inspector::ironic_project_domain_name, $project_domain_name)
  $region_name_real         = pick($::ironic::inspector::ironic_region_name, $region_name)
  $max_retries_real         = pick($::ironic::inspector::ironic_max_retries, $max_retries)
  $retry_interval_real      = pick($::ironic::inspector::ironic_retry_interval, $retry_interval)

  ironic_inspector_config {
    'ironic/auth_type':           value => $auth_type_real;
    'ironic/username':            value => $username_real;
    'ironic/password':            value => $password_real, secret => true;
    'ironic/auth_url':            value => $auth_url_real;
    'ironic/project_name':        value => $project_name_real;
    'ironic/user_domain_name':    value => $user_domain_name_real;
    'ironic/project_domain_name': value => $project_domain_name_real;
    'ironic/region_name':         value => $region_name_real;
    'ironic/endpoint_override':   value => $endpoint_override;
    'ironic/max_retries':         value => $max_retries_real;
    'ironic/retry_interval':      value => $retry_interval_real;
  }
}
