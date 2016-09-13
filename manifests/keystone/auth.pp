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
#   (required) Password for Ironic user.
#
# [*auth_name*]
#   Username for Ironic service. Defaults to 'ironic'.
#
# [*email*]
#   Email for Ironic user. Defaults to 'ironic@localhost'.
#
# [*tenant*]
#   Tenant for Ironic user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should Ironic endpoint be configured? Defaults to 'true'.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to 'true'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of 'ironic'.
#
# [*service_type*]
#   Type of service. Defaults to 'baremetal'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'Ironic Bare Metal Provisioning Service'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:6385')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:6385')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:6385')
#   This url should *not* contain any trailing '/'.
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
  $password,
  $auth_name           = 'ironic',
  $email               = 'ironic@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'ironic',
  $service_type        = 'baremetal',
  $service_description = 'Ironic Bare Metal Provisioning Service',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:6385',
  $admin_url           = 'http://127.0.0.1:6385',
  $internal_url        = 'http://127.0.0.1:6385',
) {

  include ::ironic::deps

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'ironic-server' |>
  }

  Keystone_endpoint["${region}/${service_name}::${service_type}"]  ~> Service <| name == 'ironic-server' |>

  keystone::resource::service_identity { 'ironic':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    auth_name           => $auth_name,
    service_description => $service_description,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
