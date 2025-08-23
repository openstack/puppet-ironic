#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
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
# ironic::keystone::auth
#
# Configures Ironic user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for Ironic user.
#
# [*auth_name*]
#   (Optional) Username for Ironic service.
#   Defaults to 'ironic'.
#
# [*email*]
#   (Optional) Email for Ironic user.
#   Defaults to 'ironic@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for Ironic user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to ironic user
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to ironic user.
#   Defaults to []
#
# [*configure_endpoint*]
#   (Optional) Should Ironic endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true.
#
# [*configure_service*]
#   (Optional) Should the service be configurd?
#   Defaults to True
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of 'ironic'.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'baremetal'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'Ironic Bare Metal Provisioning Service'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:6385'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:6385'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:6385'
#
# === Examples
#
#  class { 'ironic::keystone::auth':
#    public_url   => 'https://10.0.0.10:6385',
#    internal_url => 'https://10.0.0.11:6385',
#    admin_url    => 'https://10.0.0.11:6385',
#  }
#
class ironic::keystone::auth (
  String[1] $password,
  String[1] $auth_name                    = 'ironic',
  String[1] $email                        = 'ironic@localhost',
  String[1] $tenant                       = 'services',
  Array[String[1]] $roles                 = ['admin'],
  String[1] $system_scope                 = 'all',
  Array[String[1]] $system_roles          = [],
  Boolean $configure_endpoint             = true,
  Boolean $configure_user                 = true,
  Boolean $configure_user_role            = true,
  Boolean $configure_service              = true,
  String[1] $service_name                 = 'ironic',
  String[1] $service_type                 = 'baremetal',
  String[1] $service_description          = 'Ironic Bare Metal Provisioning Service',
  String[1] $region                       = 'RegionOne',
  Keystone::PublicEndpointUrl $public_url = 'http://127.0.0.1:6385',
  Keystone::EndpointUrl $admin_url        = 'http://127.0.0.1:6385',
  Keystone::EndpointUrl $internal_url     = 'http://127.0.0.1:6385',
) {
  include ironic::deps

  Keystone::Resource::Service_identity['ironic'] -> Anchor['ironic::service::end']

  keystone::resource::service_identity { 'ironic':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    configure_service   => $configure_service,
    service_name        => $service_name,
    service_type        => $service_type,
    auth_name           => $auth_name,
    service_description => $service_description,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }
}
