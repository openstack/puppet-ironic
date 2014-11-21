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
# [*service_type*]
#   Type of service. Defaults to 'baremetal'.
#
# [*public_protocol*]
#   Protocol for public endpoint. Defaults to 'http'.
#
# [*public_address*]
#   Public address for endpoint. Defaults to '127.0.0.1'.
#
# [*admin_address*]
#   Admin address for endpoint. Defaults to '127.0.0.1'.
#
# [*internal_address*]
#   Internal address for endpoint. Defaults to '127.0.0.1'.
#
# [*port*]
#   Port for endpoint. Defaults to '6385'.
#
# [*public_port*]
#   Port for public endpoint. Defaults to $port.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
class ironic::keystone::auth (
  $password,
  $auth_name          = 'ironic',
  $email              = 'ironic@localhost',
  $tenant             = 'services',
  $configure_endpoint = true,
  $service_type       = 'baremetal',
  $public_protocol    = 'http',
  $public_address     = '127.0.0.1',
  $admin_address      = '127.0.0.1',
  $internal_address   = '127.0.0.1',
  $port               = '6385',
  $public_port        = undef,
  $region             = 'RegionOne'
) {

  Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'ironic-server' |>
  Keystone_endpoint["${region}/${auth_name}"]  ~> Service <| name == 'ironic-server' |>

  if ! $public_port {
    $real_public_port = $port
  } else {
    $real_public_port = $public_port
  }

  keystone::resource::service_identity { $auth_name:
    configure_user      => true,
    configure_user_role => true,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => 'Ironic Networking Service',
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => "${public_protocol}://${public_address}:${real_public_port}/",
    internal_url        => "http://${internal_address}:${port}/",
    admin_url           => "http://${admin_address}:${port}/",
  }

}
