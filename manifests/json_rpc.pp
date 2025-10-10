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
# == Class: ironic::json_rpc
#
# Configure parameters for json_rpc
#
# === Parameters
#
# [*password*]
#   (Required) The admin password for ironic to connect to json_rpc.
#
# [*auth_strategy*]
#   (Optional) Authentication strategy used by JSON RPC.
#   Defaults to 'keystone'
#
# [*http_basic_auth_user_file*]
#   (Optional) Path to Apache format user authentication file used when
#   using auth_strategy=http_basic.
#   Defaults to $facts['os_service_default']
#
# [*host_ip*]
#   (Optional) The IP address or hostname on which JSON RPC will listen.
#   Defaults to $facts['os_service_default']
#
# [*port*]
#   (Optional) The port to use for JSON RPC'.
#   Defaults to $facts['os_service_default']
#
# [*use_ssl*]
#   (Optional) Whether to use TLS for JSON RPC'.
#   Defaults to false
#
# [*auth_type*]
#   (Optional) The authentication plugin to use when connecting to json_rpc.
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
#   (Optional) The admin username for ironic to connect to json_rpc.
#   Defaults to 'ironic'.
#
# [*user_domain_name*]
#   (Optional) The name of user's domain (required for Identity V3).
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (Optional) The name of project's domain (required for Identity V3).
#   Defaults to 'Default'
#
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to $facts['os_service_default']
#
# [*allowed_roles*]
#   (Optional) List of roles allowed to use JSON RPC.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_override*]
#   (Optional) The endpoint URL for requests for this client
#   Defaults to $facts['os_service_default']
#
# [*region_name*]
#   (Optional) Region name for connecting to swift in admin context
#   through the OpenStack Identity service.
#   Defaults to $facts['os_service_default']
#
class ironic::json_rpc (
  $password,
  Enum['noauth', 'keystone', 'http_basic'] $auth_strategy = 'keystone',
  $http_basic_auth_user_file                              = $facts['os_service_default'],
  $host_ip                                                = $facts['os_service_default'],
  $port                                                   = $facts['os_service_default'],
  Boolean $use_ssl                                        = false,
  $auth_type                                              = 'password',
  $auth_url                                               = 'http://127.0.0.1:5000',
  $project_name                                           = 'services',
  $username                                               = 'ironic',
  $user_domain_name                                       = 'Default',
  $project_domain_name                                    = 'Default',
  $system_scope                                           = $facts['os_service_default'],
  $allowed_roles                                          = $facts['os_service_default'],
  $endpoint_override                                      = $facts['os_service_default'],
  $region_name                                            = $facts['os_service_default'],
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
    'json_rpc/auth_strategy':             value => $auth_strategy;
    'json_rpc/http_basic_auth_user_file': value => $http_basic_auth_user_file;
    'json_rpc/host_ip':                   value => $host_ip;
    'json_rpc/port':                      value => $port;
    'json_rpc/use_ssl':                   value => $use_ssl;
    'json_rpc/auth_type':                 value => $auth_type;
    'json_rpc/username':                  value => $username;
    'json_rpc/password':                  value => $password, secret => true;
    'json_rpc/auth_url':                  value => $auth_url;
    'json_rpc/project_name':              value => $project_name_real;
    'json_rpc/user_domain_name':          value => $user_domain_name;
    'json_rpc/project_domain_name':       value => $project_domain_name_real;
    'json_rpc/system_scope':              value => $system_scope;
    'json_rpc/allowed_roles':             value => join(any2array($allowed_roles), ',');
    'json_rpc/endpoint_override':         value => $endpoint_override;
    'json_rpc/region_name':               value => $region_name;
  }
}
