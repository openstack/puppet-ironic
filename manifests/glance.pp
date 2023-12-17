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
# [*password*]
#   (Required) The admin password for ironic to connect to glance.
#
# [*auth_type*]
#   (Optional) The authentication plugin to use when connecting to glance.
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
#   (Optional) The admin username for ironic to connect to glance.
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
#   (Optional) Region name for connecting to glance in admin context
#   through the OpenStack Identity service.
#   Defaults to $facts['os_service_default']
#
# [*num_retries*]
#   (Optional) Number retries when downloading an image from glance.
#   Defaults to $facts['os_service_default']
#
# [*api_insecure*]
#   (Optional) Allow to perform insecure SSL (https) requests to glance.
#   Defaults to $facts['os_service_default']
#
# [*swift_account*]
#   (Optional) The account that Glance uses to communicate with Swift.
#   The format is "AUTH_uuid".
#   Can not be set together with swift_account_project_name.
#   Defaults to $facts['os_service_default']
#
# [*swift_account_prefix*]
#   (Optional) The prefix added to the project uuid to determine the swift
#   account.
#   Defaults to $facts['os_service_default']
#
# [*swift_account_project_name*]
#   (Optional) The project of account that Glance uses to communicate with Swift.
#   Will be converted to UUID, and option glance/swift_account will be set in
#   the "AUTH_uuid" format.
#   Can not be set together with swift_account.
#   Defaults to undef, which leaves the configuration intact
#
# [*swift_container*]
#   (Optional) Swift container where Glance images are stored. Used for
#   generating temporary URLs.
#   Defaults to $facts['os_service_default']
#
# [*swift_endpoint_url*]
#   (Optional) Swift endpoint to use for generating temporary URLs.
#   Defaults to $facts['os_service_default']
#
# [*swift_temp_url_key*]
#   (Optional) The secret token given to Swift to allow temporary URL
#   downloads. Required for several drivers (e.g. agent_ipmitool).
#   Defaults to $facts['os_service_default']
#
# [*swift_temp_url_duration*]
#   (Optional) The length of time in seconds that the temporary URL will be
#   valid for.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_override*]
#   (Optional) The endpoint URL for requests for this client
#   Defaults to $facts['os_service_default']
#
class ironic::glance (
  $password,
  $auth_type                  = 'password',
  $auth_url                   = 'http://127.0.0.1:5000',
  $project_name               = 'services',
  $username                   = 'ironic',
  $user_domain_name           = 'Default',
  $project_domain_name        = 'Default',
  $system_scope               = $facts['os_service_default'],
  $region_name                = $facts['os_service_default'],
  $num_retries                = $facts['os_service_default'],
  $api_insecure               = $facts['os_service_default'],
  $swift_account              = $facts['os_service_default'],
  $swift_account_prefix       = $facts['os_service_default'],
  $swift_account_project_name = undef,
  $swift_container            = $facts['os_service_default'],
  $swift_endpoint_url         = $facts['os_service_default'],
  $swift_temp_url_key         = $facts['os_service_default'],
  $swift_temp_url_duration    = $facts['os_service_default'],
  $endpoint_override          = $facts['os_service_default'],
) {

  include ironic::deps

  if ($swift_account_project_name and !is_service_default($swift_account)) {
    fail('swift_account_project_name and swift_account can not be specified in the same time.')
  }

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  ironic_config {
    'glance/auth_type':               value => $auth_type;
    'glance/username':                value => $username;
    'glance/password':                value => $password, secret => true;
    'glance/auth_url':                value => $auth_url;
    'glance/project_name':            value => $project_name_real;
    'glance/user_domain_name':        value => $user_domain_name;
    'glance/project_domain_name':     value => $project_domain_name_real;
    'glance/system_scope':            value => $system_scope;
    'glance/region_name':             value => $region_name;
    'glance/num_retries':             value => $num_retries;
    'glance/insecure':                value => $api_insecure;
    'glance/swift_account_prefix':    value => $swift_account_prefix;
    'glance/swift_container':         value => $swift_container;
    'glance/swift_endpoint_url':      value => $swift_endpoint_url;
    'glance/swift_temp_url_key':      value => $swift_temp_url_key, secret => true;
    'glance/swift_temp_url_duration': value => $swift_temp_url_duration;
    'glance/endpoint_override':       value => $endpoint_override;
  }

  if $swift_account_project_name {
    ironic_config {
      'glance/swift_account': value => $swift_account_project_name, transform_to => 'project_uuid';
    }
  } else {
    ironic_config {
      'glance/swift_account': value => $swift_account;
    }
  }
}
