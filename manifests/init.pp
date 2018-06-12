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
# [*default_resource_class*]
#   (optional) Default resource class to use for new nodes when no resource
#   class is explicitly requested.
#   Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#   (optional) Seconds to wait for a response from a call. (integer value)
#   Defaults to $::os_service_default.
#
# [*control_exchange*]
#   (optional) What RPC queue/exchange to use (string value)
#   Defaults to $::os_service_default
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $::os_service_default
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
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
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
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $::os_service_default.
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $::os_service_default.
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $::os_service_default.
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $::os_service_default.
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $::os_service_default.
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $::os_service_default.
#
# [*amqp_allow_insecure_clients*]
#   (Optional) Accept clients using either SSL or plain TCP
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $::os_service_default.
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $::os_service_default.
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $::os_service_default.
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
#   If set to $::os_service_default, it will not log to any directory.
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
# [*sync_db*]
#   Enable dbsync
#   Defaults to true
#
# [*db_online_data_migrations*]
#   (optional) Run online_data_migrations - required on upgrade.
#   Defaults to false.
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the ironic config.
#   Defaults to false.
#
class ironic (
  $enabled                            = true,
  $package_ensure                     = 'present',
  $debug                              = undef,
  $my_ip                              = $::os_service_default,
  $use_syslog                         = undef,
  $use_stderr                         = undef,
  $log_facility                       = undef,
  $log_dir                            = undef,
  $auth_strategy                      = 'keystone',
  $default_resource_class             = $::os_service_default,
  $control_exchange                   = $::os_service_default,
  $rpc_response_timeout               = $::os_service_default,
  $default_transport_url              = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_failover_strategy            = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $amqp_server_request_prefix         = $::os_service_default,
  $amqp_broadcast_prefix              = $::os_service_default,
  $amqp_group_request_prefix          = $::os_service_default,
  $amqp_container_name                = $::os_service_default,
  $amqp_idle_timeout                  = $::os_service_default,
  $amqp_trace                         = $::os_service_default,
  $amqp_ssl_ca_file                   = $::os_service_default,
  $amqp_ssl_cert_file                 = $::os_service_default,
  $amqp_ssl_key_file                  = $::os_service_default,
  $amqp_ssl_key_password              = $::os_service_default,
  $amqp_allow_insecure_clients        = $::os_service_default,
  $amqp_sasl_mechanisms               = $::os_service_default,
  $amqp_sasl_config_dir               = $::os_service_default,
  $amqp_sasl_config_name              = $::os_service_default,
  $amqp_username                      = $::os_service_default,
  $amqp_password                      = $::os_service_default,
  $database_connection                = undef,
  $database_max_retries               = undef,
  $database_idle_timeout              = undef,
  $database_reconnect_interval        = undef,
  $database_retry_interval            = undef,
  $database_min_pool_size             = undef,
  $database_max_pool_size             = undef,
  $database_max_overflow              = undef,
  $sync_db                            = true,
  $db_online_data_migrations          = false,
  $purge_config                       = false,
) {

  include ::ironic::deps
  include ::ironic::logging
  include ::ironic::db
  include ::ironic::params

  include ::ironic::glance
  include ::ironic::neutron

  ensure_resource( 'package', 'ironic-common', {
      ensure => $package_ensure,
      name   => $::ironic::params::common_package_name,
      tag    => ['openstack', 'ironic-package'],})

  package { 'ironic-lib':
    ensure => $package_ensure,
    name   => $::ironic::params::lib_package_name,
    tag    => ['openstack', 'ironic-package'],
  }

  resources { 'ironic_config':
    purge => $purge_config,
  }

  ironic_config {
    'DEFAULT/auth_strategy':           value => $auth_strategy;
    'DEFAULT/my_ip':                   value => $my_ip;
    'DEFAULT/default_resource_class':  value => $default_resource_class;
  }

  if $sync_db {
    include ::ironic::db::sync
  }

  if $db_online_data_migrations {
    include ::ironic::db::online_data_migrations
  }

  oslo::messaging::default {'ironic_config':
      transport_url        => $default_transport_url,
      rpc_response_timeout => $rpc_response_timeout,
      control_exchange     => $control_exchange,
  }

  oslo::messaging::rabbit {'ironic_config':
    rabbit_use_ssl              => $rabbit_use_ssl,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    kombu_failover_strategy     => $kombu_failover_strategy,
    amqp_durable_queues         => $amqp_durable_queues,
    kombu_compression           => $kombu_compression,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_version           => $kombu_ssl_version,
    rabbit_ha_queues            => $rabbit_ha_queues,
  }

  oslo::messaging::amqp { 'ironic_config':
    server_request_prefix  => $amqp_server_request_prefix,
    broadcast_prefix       => $amqp_broadcast_prefix,
    group_request_prefix   => $amqp_group_request_prefix,
    container_name         => $amqp_container_name,
    idle_timeout           => $amqp_idle_timeout,
    trace                  => $amqp_trace,
    ssl_ca_file            => $amqp_ssl_ca_file,
    ssl_cert_file          => $amqp_ssl_cert_file,
    ssl_key_file           => $amqp_ssl_key_file,
    ssl_key_password       => $amqp_ssl_key_password,
    allow_insecure_clients => $amqp_allow_insecure_clients,
    sasl_mechanisms        => $amqp_sasl_mechanisms,
    sasl_config_dir        => $amqp_sasl_config_dir,
    sasl_config_name       => $amqp_sasl_config_name,
    username               => $amqp_username,
    password               => $amqp_password,
  }

}
