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
# == Class: ironic::glance
#
# [*auth_type*]
#   The authentication plugin to use when connecting to glance.
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
#   The admin username for ironic to connect to glance.
#   Defaults to 'ironic'.
#
# [*password*]
#   The admin password for ironic to connect to glance.
#   Defaults to $::os_service_default
#
# [*user_domain_name*]
#   The name of user's domain (required for Identity V3).
#   Defaults to $::os_service_default
#
# [*project_domain_name*]
#   The name of project's domain (required for Identity V3).
#   Defaults to $::os_service_default
#
# [*api_servers*]
#   (optional) A list of the glance api servers available to ironic.
#   Should be an array with [hostname|ip]:port
#   Defaults to $::os_service_default
#
# [*num_retries*]
#   (optional) Number retries when downloading an image from glance.
#   Defaults to $::os_service_default
#
# [*api_insecure*]
#   (optional) Allow to perform insecure SSL (https) requests to glance.
#   Defaults to $::os_service_default
#
class ironic::glance (
  $auth_type            = 'password',
  $auth_url             = $::os_service_default,
  $project_name         = 'services',
  $username             = 'ironic',
  $password             = $::os_service_default,
  $user_domain_name     = $::os_service_default,
  $project_domain_name  = $::os_service_default,
  $api_servers          = $::os_service_default,
  $num_retries          = $::os_service_default,
  $api_insecure         = $::os_service_default,
) {

  $api_servers_real = pick($::ironic::glance_api_servers, $api_servers)
  if is_array($api_servers_real) {
    $api_servers_converted = join($api_servers_real, ',')
  } else {
    $api_servers_converted = $api_servers_real
  }

  $num_retries_real = pick($::ironic::glance_num_retries, $num_retries)
  $api_insecure_real = pick($::ironic::glance_api_insecure, $api_insecure)

  ironic_config {
    'glance/auth_type':            value => $auth_type;
    'glance/username':             value => $username;
    'glance/password':             value => $password, secret => true;
    'glance/auth_url':             value => $auth_url;
    'glance/project_name':         value => $project_name;
    'glance/user_domain_name':     value => $user_domain_name;
    'glance/project_domain_name':  value => $project_domain_name;
    'glance/glance_api_servers':   value => $api_servers_converted;
    'glance/glance_num_retries':   value => $num_retries_real;
    'glance/glance_api_insecure':  value => $api_insecure_real;
  }
}
