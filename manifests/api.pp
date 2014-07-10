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
# [*host_ip*]
#   (optional) The listen IP for the Ironic API server.
#   Should be an valid IP address
#   Defaults to '0.0.0.0'.
#
# [*port*]
#   (optional) The port for the Ironic API server.
#   Should be an valid port
#   Defaults to '0.0.0.0'.
#
# [*max_limit*]
#   (optional) The maximum number of items returned in a single response
#   from a collection resource.
#   Should be an valid interger
#   Defaults to '1000'.
#

class ironic::api (
  $package_ensure = 'present',
  $enabled        = true,
  $host_ip        = '0.0.0.0',
  $port           = '6385',
  $max_limit      = '1000'
) {

  include ironic::params

  Ironic_config<||> ~> Service['ironic-api']

  # Configure ironic.conf
  ironic_config {
    'api/host_ip': value   => $host_ip;
    'api/port': value      => $port;
    'api/max_limit': value => $max_limit;
  }

  # Install package
  if $::ironic::params::api_package {
    Package['ironic-api'] -> Service['ironic-api']
    Package['ironic-api'] -> Ironic_config<||>
    package { 'ironic-api':
      ensure => $package_ensure,
      name   => $::ironic::params::api_package,
    }
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  # Manage service
  service { 'ironic-api':
    ensure    => $ensure,
    name      => $::ironic::params::api_service,
    enable    => $enabled,
    hasstatus => true,
  }

}
