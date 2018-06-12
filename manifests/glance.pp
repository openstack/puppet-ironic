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
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   The name of project's domain (required for Identity V3).
#   Defaults to 'Default'
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
# [*swift_account*]
#   (optional) The account that Glance uses to communicate with Swift.
#   The format is "AUTH_uuid".
#   Can not be set together with swift_account_project_name.
#   Defaults to $::os_service_default
#
# [*swift_account_project_name*]
#   (optional) The project of account that Glance uses to communicate with Swift.
#   Will be converted to UUID, and option glance/swift_account will be set in
#   the "AUTH_uuid" format.
#   Can not be set together with swift_account.
#   Defaults to undef, which leaves the configuration intact
#
# [*swift_container*]
#   (optional) Swift container where Glance images are stored. Used for
#   generating temporary URLs.
#   Defaults to $::os_service_default
#
# [*swift_endpoint_url*]
#   (optional) Swift endpoint to use for generating temporary URLs.
#   Defaults to $::os_service_default
#
# [*swift_temp_url_key*]
#   (optional) The secret token given to Swift to allow temporary URL
#   downloads. Required for several drivers (e.g. agent_ipmitool).
#   Defaults to $::os_service_default
#
# [*swift_temp_url_duration*]
#   (optional) The length of time in seconds that the temporary URL will be
#   valid for.
#   Defaults to $::os_service_default
#
class ironic::glance (
  $auth_type                  = 'password',
  $auth_url                   = $::os_service_default,
  $project_name               = 'services',
  $username                   = 'ironic',
  $password                   = $::os_service_default,
  $user_domain_name           = 'Default',
  $project_domain_name        = 'Default',
  $api_servers                = $::os_service_default,
  $num_retries                = $::os_service_default,
  $api_insecure               = $::os_service_default,
  $swift_account              = $::os_service_default,
  $swift_container            = $::os_service_default,
  $swift_endpoint_url         = $::os_service_default,
  $swift_temp_url_key         = $::os_service_default,
  $swift_temp_url_duration    = $::os_service_default,
  $swift_account_project_name = undef,
) {

  if is_array($api_servers) {
    $api_servers_converted = join($api_servers, ',')
  } else {
    $api_servers_converted = $api_servers
  }

  if ($swift_account_project_name and !is_service_default($swift_account)) {
    fail('swift_account_project_name and swift_account can not be specified in the same time.')
  }

  ironic_config {
    'glance/auth_type':               value => $auth_type;
    'glance/username':                value => $username;
    'glance/password':                value => $password, secret => true;
    'glance/auth_url':                value => $auth_url;
    'glance/project_name':            value => $project_name;
    'glance/user_domain_name':        value => $user_domain_name;
    'glance/project_domain_name':     value => $project_domain_name;
    'glance/glance_api_servers':      value => $api_servers_converted;
    'glance/glance_num_retries':      value => $num_retries;
    'glance/glance_api_insecure':     value => $api_insecure;
    'glance/swift_container':         value => $swift_container;
    'glance/swift_endpoint_url':      value => $swift_endpoint_url;
    'glance/swift_temp_url_key':      value => $swift_temp_url_key, secret => true;
    'glance/swift_temp_url_duration': value => $swift_temp_url_duration;
  }

  if $swift_account_project_name {
    ironic_config {
      'glance/swift_account':           value => $swift_account_project_name, transform_to => 'project_uuid';
    }
  } else {
    ironic_config {
      'glance/swift_account':           value => $swift_account;
    }
  }
}
