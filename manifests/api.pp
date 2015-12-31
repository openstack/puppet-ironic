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

# Configure the API service in Ironic
#
# === Parameters
#
# [*package_ensure*]
#   (optional) Control the ensure parameter for the package ressource.
#   Defaults to 'present'.
#
# [*enabled*]
#   (optional) Define if the service must be enabled or not.
#   Defaults to true.
#
# [*host_ip*]
#   (optional) The listen IP for the Ironic API server.
#   Should be an valid IP address
#   Defaults to '0.0.0.0'.
#
# [*port*]
#   (optional) The port for the Ironic API server.
#   Should be an valid port
#   Defaults to '6385'.
#
# [*max_limit*]
#   (optional) The maximum number of items returned in a single response
#   from a collection resource.
#   Should be an valid interger
#   Defaults to '1000'.
#
# [*auth_uri*]
#   (optional) Complete public Identity API endpoint.
#   Defaults to 'http://127.0.0.1:5000/'.
#
# [*identity_uri*]
#   (optional) Complete admin Identity API endpoint.
#   Defaults to 'http://127.0.0.1:35357/'.
#
# [*auth_version*]
#   (optional) DEPRECATED. API version of the admin Identity API endpoint
#   for example, use 'v3.0' for the keystone version 3.0 api
#   Defaults to false
#
# [*admin_tenant_name*]
#   (optional) The name of the tenant to create in keystone for use by the ironic services
#   Defaults to 'services'
#
# [*admin_user*]
#   (optional) The name of the user to create in keystone for use by the ironic services
#   Defaults to 'ironic'
#
# [*neutron_url*]
#   (optional) The Neutron URL to be used for requests from ironic
#   Defaults to 'http://127.0.0.1:9696/'
#
# [*admin_password*]
#   (required) The password to set for the ironic admin user in keystone
#
# [*workers*]
#   (Optional) The number of workers to spawn.
#   Defaults to $::os_service_default.
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of ironic-api.
#   If the value is 'httpd', this means ironic-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'ironic::wsgi::apache'...}
#   to make ironic-api be a web app using apache mod_wsgi.
#   Defaults to '$::ironic::params::api_service'
#

class ironic::api (
  $package_ensure    = 'present',
  $enabled           = true,
  $service_name      = $::ironic::params::api_service,
  $host_ip           = '0.0.0.0',
  $port              = '6385',
  $max_limit         = '1000',
  $workers           = $::os_service_default,
  $auth_uri          = 'http://127.0.0.1:5000/',
  $identity_uri      = 'http://127.0.0.1:35357/',
  $admin_tenant_name = 'services',
  $admin_user        = 'ironic',
  $neutron_url       = 'http://127.0.0.1:9696/',
  $admin_password,
  # DEPRECATED PARAMETER
  $auth_version      = false,
) inherits ironic::params {

  include ::ironic::params
  include ::ironic::policy

  Ironic_config<||> ~> Service[$service_name]
  Class['ironic::policy'] ~> Service[$service_name]

  # Configure ironic.conf
  ironic_config {
    'api/host_ip':     value => $host_ip;
    'api/port':        value => $port;
    'api/max_limit':   value => $max_limit;
    'api/api_workers': value => $workers;
  }

  # Install package
  if $::ironic::params::api_package {
    Package['ironic-api'] -> Class['ironic::policy']
    Package['ironic-api'] -> Service[$service_name]
    package { 'ironic-api':
      ensure => $package_ensure,
      name   => $::ironic::params::api_package,
      tag    => ['openstack', 'ironic-package'],
    }
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  if $service_name == $::ironic::params::api_service {
    service { 'ironic-api':
      ensure     => $ensure,
      name       => $::ironic::params::api_service,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'ironic-service',
    }
  } elsif $service_name == 'httpd' {
    include ::apache::params
    service { 'ironic-api':
      ensure => 'stopped',
      name   => $::ironic::params::api_service,
      enable => false,
      tag    => 'ironic-service',
    }

    # we need to make sure ironic-api/eventlet is stopped before trying to start apache
    Service['ironic-api'] -> Service[$service_name]
  } else {
    fail('Invalid service_name. Either ironic-api/openstack-ironic-api for running as a standalone service, or httpd for being run by a httpd server')
  }

  if $auth_version {
    warning('auth_version parameter is deprecated and has no effect during Mitaka and will be dropped during N cycle.')
  }

  ironic_config {
    'keystone_authtoken/admin_tenant_name': value => $admin_tenant_name;
    'keystone_authtoken/admin_user':        value => $admin_user;
    'keystone_authtoken/admin_password':    value => $admin_password, secret => true;
    'keystone_authtoken/auth_uri':          value => $auth_uri;
    'keystone_authtoken/identity_uri':      value => $identity_uri;
    'neutron/url':                          value => $neutron_url;
  }

}
