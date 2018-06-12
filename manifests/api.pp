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
# [*public_endpoint*]
#   (Optional) Public URL to use when building the links to the API resources
#   Defaults to $::os_service_default
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
class ironic::api (
  $package_ensure               = 'present',
  $enabled                      = true,
  $service_name                 = $::ironic::params::api_service,
  $host_ip                      = '0.0.0.0',
  $port                         = '6385',
  $max_limit                    = '1000',
  $workers                      = $::os_service_default,
  $public_endpoint              = $::os_service_default,
  $enable_proxy_headers_parsing = $::os_service_default,
) inherits ironic::params {

  include ::ironic::deps
  include ::ironic::params
  include ::ironic::policy
  include ::ironic::api::authtoken

  # Configure ironic.conf
  ironic_config {
    'api/host_ip':         value => $host_ip;
    'api/port':            value => $port;
    'api/max_limit':       value => $max_limit;
    'api/api_workers':     value => $workers;
    'api/public_endpoint': value => $public_endpoint;
  }

  # Install package
  if $::ironic::params::api_package {
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
    Keystone_endpoint<||> -> Service['ironic-api']
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
    fail("Invalid service_name. Either ironic-api/openstack-ironic-api for running as a \
standalone service, or httpd for being run by a httpd server")
  }

  oslo::middleware { 'ironic_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
  }

}
