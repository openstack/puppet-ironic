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
# [*auth_strategy*]
#   (optional) Authentication strategy used by JSON RPC.
#   Defaults to 'keystone'
#
# [*http_basic_auth_user_file*]
#   (optional) Path to Apache format user authentication file used when
#   using auth_strategy=http_basic.
#   Defaults to $::os_service_default
#
# [*host_ip*]
#   (optional) The IP address or hostname on which JSON RPC will listen.
#   Defaults to $::os_service_default
#
# [*port*]
#   (optional) The port to use for JSON RPC'.
#   Defaults to $::os_service_default
#
# [*use_ssl*]
#   (optional) Whether to use TLS for JSON RPC'.
#   Defaults to false
#
# [*auth_type*]
#   (optional) The authentication plugin to use when connecting to json_rpc.
#   Defaults to 'password'
#
# [*auth_url*]
#   (optional) The address of the keystone api endpoint.
#   Defaults to $::os_service_default
#
# [*project_name*]
#   (optional) The Keystone project name.
#   Defaults to 'services'
#
# [*username*]
#   (optional) The admin username for ironic to connect to json_rpc.
#   Defaults to 'ironic'.
#
# [*password*]
#   (optional) The admin password for ironic to connect to json_rpc.
#   Defaults to $::os_service_default
#
# [*user_domain_name*]
#   (optional) The name of user's domain (required for Identity V3).
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (optional) The name of project's domain (required for Identity V3).
#   Defaults to 'Default'
#
# [*region_name*]
#   (optional) Region name for connecting to swift in admin context
#   through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*endpoint_override*]
#   (optional) The endpoint URL for requests for this client
#   Defaults to $::os_service_default
#
class ironic::json_rpc (
  $auth_strategy             = 'keystone',
  $http_basic_auth_user_file = $::os_service_default,
  $host_ip                   = $::os_service_default,
  $port                      = $::os_service_default,
  $use_ssl                   = false,
  $auth_type                 = 'password',
  $auth_url                  = $::os_service_default,
  $project_name              = 'services',
  $username                  = 'ironic',
  $password                  = $::os_service_default,
  $user_domain_name          = 'Default',
  $project_domain_name       = 'Default',
  $endpoint_override         = $::os_service_default,
  $region_name               = $::os_service_default,
) {

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
    'json_rpc/project_name':              value => $project_name;
    'json_rpc/user_domain_name':          value => $user_domain_name;
    'json_rpc/project_domain_name':       value => $project_domain_name;
    'json_rpc/endpoint_override':         value => $endpoint_override;
    'json_rpc/region_name':               value => $region_name;
  }
}
