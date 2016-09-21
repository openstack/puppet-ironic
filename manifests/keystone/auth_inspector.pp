#
# Copyright (C) 2015 Red Hat Inc.
#
# Author: Dan Prince <dprince@redhat.com>
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
# ironic::keystone::auth_inspector
#
# Configures Baremetal Introspection user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for Baremetal Introspection user.
#
# [*auth_name*]
#   Username for Bare Metal Introspection Service. Defaults to 'ironic-inspector'.
#
# [*email*]
#   Email for Baremetal Introspection user. Defaults to 'baremetal-introspection@localhost'.
#
# [*tenant*]
#   Tenant for Baremetal Introspection user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should Baremetal Introspection endpoint be configured? Defaults to 'true'.
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
#   Defaults to the value of auth_name, but must differ from the value.
#
# [*service_type*]
#   Type of service. Defaults to 'baremetal-introspection'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'Bare Metal Introspection Service'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:5050')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:5050')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:5050')
#   This url should *not* contain any trailing '/'.
#
# === Examples
#
#  class { 'ironic::keystone::auth_inspector':
#    public_url   => 'https://10.0.0.10:5050',
#    internal_url => 'https://10.0.0.11:5050',
#    admin_url    => 'https://10.0.0.11:5050',
#  }
#
class ironic::keystone::auth_inspector (
  $password,
  $auth_name           = 'ironic-inspector',
  $email               = 'baremetal-introspection@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = undef,
  $service_type        = 'baremetal-introspection',
  $service_description = 'Bare Metal Introspection Service',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:5050',
  $admin_url           = 'http://127.0.0.1:5050',
  $internal_url        = 'http://127.0.0.1:5050',
) {

  include ::ironic::deps

  $real_service_name = pick($service_name, $auth_name)

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'ironic-inspector' |>
  }

  Keystone_endpoint["${region}/${real_service_name}::${service_type}"]  ~> Service <| name == 'ironic-inspector' |>

  keystone::resource::service_identity { $auth_name:
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
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
