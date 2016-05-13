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
# == Class: ironic
#
# Installs the ironic package and configures /etc/ironic/ironic.conf
#
# === Parameters:
#
# [*enabled*]
#   (required) Whether or not to enable the ironic service
#   true/false
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to 'present'
#
# [*verbose*]
#   (optional) Verbose logging
#   Defaults to False
#
# [*debug*]
#   (optional) Print debug messages in the logs
#   Defaults to False
#
# [*my_ip*]
#   (optional) IP address of this host.
#   If unset, will determine the IP programmatically. If unable to do so, will use
#   "127.0.0.1".
#   Defaults to $::os_service_default.
#
# [*auth_strategy*]
#   (optional) Default protocol to use when connecting to glance
#   Defaults to 'keystone'. 'https' is the only other valid option for SSL
#
# [*enabled_drivers*]
#  (optional) Array of drivers to load during service
#  initialization.
#  Defaults to ['pxe_ipmitool'].
#
# [*rpc_response_timeout*]
#   (optional) Seconds to wait for a response from a call. (integer value)
#   Defaults to $::os_service_default.
#
# [*control_exchange*]
#   (optional) What RPC queue/exchange to use (string value)
#   Defaults to $::os_service_default
#
# [*rpc_backend*]
#   (optional) what rpc/queuing service to use (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_host*]
#   (optional) IP or hostname of the rabbit server. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_hosts*]
#   (optional) List of clustered rabbit servers. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_user*]
#   (optional) User to connect to the rabbit server.
#   Defaults to undef.
#   Deprecated, use rabbit_userid instead.
#
# [*rabbit_userid*]
#   (optional) User used to connect to rabbitmq. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_port*]
#   (optional) Port for rabbitmq instance. (port value)
#   Defaults to $::os_service_default
#
# [*rabbit_password*]
#   (optional) Password used to connect to rabbitmq. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_virtual_host*]
#   (optional) The RabbitMQ virtual host. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ. (boolean value)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   Requires kombu >= 3.0.7 and amqp >= 1.4.0. (integer value)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period
#   to check the heartbeat on RabbitMQ connection.
#   i.e. rabbit_heartbeat_rate=2 when rabbit_heartbeat_timeout_threshold=60,
#   the heartbeat will be checked every 30 seconds. (integer value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification. (floating point value)
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq. (boolean value)
#   Defaults to $::os_service_default
#
# [*use_syslog*]
#   (optional) Use syslog for logging
#   Defaults to undef.
#
# [*log_facility*]
#   (optional) Syslog facility to receive log lines
#   Defaults to undef.
#
# [*use_stderr*]
#   (optional) Use stderr for logging
#   Defaults to undef.
#
# [*log_dir*]
#   (optional) Directory where logs should be stored.
#   If set to boolean false, it will not log to any directory.
#   Defaults to undef.
#
# [*database_connection*]
#   (optional) Connection url for the ironic database.
#   Defaults to: undef
#
# [*database_max_retries*]
#   (optional) Database reconnection retry times.
#   Defaults to: undef
#
# [*database_idle_timeout*]
#   (optional) Timeout before idle db connections are reaped.
#   Defaults to: undef
#
# [*database_reconnect_interval*]
#   (optional) Database reconnection interval in seconds.
#   Defaults to: undef
#
# [*database_retry_interval*]
#   (optional) Database reconnection interval in seconds.
#   Defaults to: undef
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to: undef
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to: undef
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to: undef
#
# [*glance_api_servers*]
#   (optional) A list of the glance api servers available to ironic.
#   Should be an array with [hostname|ip]:port
#   Defaults to undef
#
# [*glance_num_retries*]
#   (optional) Number retries when downloading an image from glance.
#   Defaults to 0
#
# [*glance_api_insecure*]
#   (optional) Allow to perform insecure SSL (https) requests to glance.
#   Defaults to false
#
# [*sync_db*]
#   Enable dbsync
#   Defaults to true
#
class ironic (
  $enabled                            = true,
  $package_ensure                     = 'present',
  $verbose                            = undef,
  $debug                              = undef,
  $my_ip                              = $::os_service_default,
  $use_syslog                         = undef,
  $use_stderr                         = undef,
  $log_facility                       = undef,
  $log_dir                            = undef,
  $auth_strategy                      = 'keystone',
  $enabled_drivers                    = ['pxe_ipmitool'],
  $control_exchange                   = $::os_service_default,
  $rpc_response_timeout               = $::os_service_default,
  $rpc_backend                        = $::os_service_default,
  $rabbit_host                        = $::os_service_default,
  $rabbit_hosts                       = $::os_service_default,
  $rabbit_password                    = $::os_service_default,
  $rabbit_port                        = $::os_service_default,
  $rabbit_userid                      = $::os_service_default,
  $rabbit_virtual_host                = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $database_connection                = undef,
  $database_max_retries               = undef,
  $database_idle_timeout              = undef,
  $database_reconnect_interval        = undef,
  $database_retry_interval            = undef,
  $database_min_pool_size             = undef,
  $database_max_pool_size             = undef,
  $database_max_overflow              = undef,
  $glance_api_servers                 = undef,
  $glance_num_retries                 = '0',
  $glance_api_insecure                = false,
  $sync_db                            = true,
  # DEPRECATED PARAMETERS
  $rabbit_user                 = undef,
) {

  include ::ironic::logging
  include ::ironic::db
  include ::ironic::params

  if $rabbit_user {
    warning('The rabbit_user parameter is deprecated. Please use rabbit_userid instead.')
    $rabbit_user_real = $rabbit_user
  } else {
    $rabbit_user_real = $rabbit_userid
  }

  file { '/etc/ironic':
    ensure  => directory,
    require => Package['ironic-common'],
    group   => 'ironic',
  }

  file { '/etc/ironic/ironic.conf':
    require => Package['ironic-common'],
    group   => 'ironic',
  }

  package { 'ironic-common':
    ensure => $package_ensure,
    name   => $::ironic::params::common_package_name,
    tag    => ['openstack', 'ironic-package'],
  }

  validate_array($enabled_drivers)

  # On Ubuntu, ipmitool dependency is missing and ironic-conductor fails to start.
  # https://bugs.launchpad.net/cloud-archive/+bug/1572800
  if member($enabled_drivers, 'pxe_ipmitool') and $::osfamily == 'Debian' {
    ensure_packages('ipmitool',
      {
        ensure => $package_ensure,
        tag    => ['openstack', 'ironic-package'],
      }
    )
  }

  if is_array($glance_api_servers) {
    ironic_config {
      'glance/glance_api_servers': value => join($glance_api_servers, ',');
    }
  } elsif is_string($glance_api_servers) {
    ironic_config {
      'glance/glance_api_servers': value => $glance_api_servers;
    }
  }

  ironic_config {
    'DEFAULT/auth_strategy':           value => $auth_strategy;
    'DEFAULT/enabled_drivers':         value => join($enabled_drivers, ',');
    'DEFAULT/my_ip':                   value => $my_ip;
    'glance/glance_num_retries':       value => $glance_num_retries;
    'glance/glance_api_insecure':      value => $glance_api_insecure;
  }

  if $sync_db {
    include ::ironic::db::sync
  }

  oslo::messaging::default {'ironic_config':
      rpc_response_timeout => $rpc_response_timeout,
      control_exchange     => $control_exchange,
  }

  if $rpc_backend in [$::os_service_default, 'ironic.openstack.common.rpc.impl_kombu', 'rabbit'] {
    oslo::messaging::rabbit {'ironic_config':
      rabbit_password             => $rabbit_password,
      rabbit_userid               => $rabbit_user_real,
      rabbit_virtual_host         => $rabbit_virtual_host,
      rabbit_use_ssl              => $rabbit_use_ssl,
      heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
      heartbeat_rate              => $rabbit_heartbeat_rate,
      kombu_reconnect_delay       => $kombu_reconnect_delay,
      amqp_durable_queues         => $amqp_durable_queues,
      kombu_compression           => $kombu_compression,
      kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
      kombu_ssl_certfile          => $kombu_ssl_certfile,
      kombu_ssl_keyfile           => $kombu_ssl_keyfile,
      kombu_ssl_version           => $kombu_ssl_version,
      rabbit_hosts                => $rabbit_hosts,
      rabbit_host                 => $rabbit_host,
      rabbit_port                 => $rabbit_port,
      rabbit_ha_queues            => $rabbit_ha_queues,
    }
  } else {
    ironic_config { 'DEFAULT/rpc_backend': value => $rpc_backend }
  }

}
