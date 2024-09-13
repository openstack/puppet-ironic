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
# [*host*]
#   (optional) Name of this node.
#   Defaults to $facts['os_service_default'].
#
# [*my_ip*]
#   (optional) IP address of this host.
#   If unset, will determine the IP programmatically. If unable to do so, will use
#   "127.0.0.1".
#   Defaults to $facts['os_service_default'].
#
# [*my_ipv6*]
#   (optional) IP address of this host using IPv6.
#   Defaults to $facts['os_service_default'].
#
# [*auth_strategy*]
#   (optional) Default protocol to use when connecting to glance
#   Defaults to 'keystone'. 'https' is the only other valid option for SSL
#
# [*default_resource_class*]
#   (optional) Default resource class to use for new nodes when no resource
#   class is explicitly requested.
#   Defaults to $facts['os_service_default']
#
# [*executor_thread_pool_size*]
#   (optional) Size of executor thread pool when executor is threading or eventlet.
#   Defaults to $facts['os_service_default'].
#
# [*rpc_response_timeout*]
#   (optional) Seconds to wait for a response from a call. (integer value)
#   Defaults to $facts['os_service_default'].
#
# [*rpc_transport*]
#   (optional) Defines a remote procedure call transport between conductor and
#   API processes, such as using a messaging broker or JSON RPC.
#   Defaults to $facts['os_service_default']
#
# [*control_exchange*]
#   (optional) What RPC queue/exchange to use (string value)
#   Defaults to $facts['os_service_default']
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   Requires kombu >= 3.0.7 and amqp >= 1.4.0. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period
#   to check the heartbeat on RabbitMQ connection.
#   i.e. rabbit_heartbeat_rate=2 when rabbit_heartbeat_timeout_threshold=60,
#   the heartbeat will be checked every 30 seconds. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_queue*]
#   (Optional) Use quorum queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_quorum_queue*]
#   (Optional) Use quorum queues for transients queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_delivery_limit*]
#   (Optional) Each time a message is rdelivered to a consumer, a counter is
#   incremented. Once the redelivery count exceeds the delivery limit
#   the message gets dropped or dead-lettered.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_length*]
#   (Optional) Limit the number of messages in the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_bytes*]
#   (Optional) Limit the number of memory bytes used by the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled). (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled). (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification. (floating point value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq. (boolean value)
#   Defaults to $facts['os_service_default']
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
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*notification_driver*]
#   (Optional) Driver or drivers to handle sending notifications.
#   Value can be a string or a list.
#   Defaults to $facts['os_service_default']
#
# [*notification_topics*]
#   (optional) AMQP topic used for OpenStack notifications
#   Defaults to $facts['os_service_default']
#
# [*notification_level*]
#   (optional) Notification level for outgoing notifications
#   Defaults to $facts['os_service_default']
#
# [*versioned_notifications_topics*]
#   (optional) Topics for the versioned notifications issued by Ironic
#   Defaults to $facts['os_service_default']
#
# [*rbac_service_role_elevated_access*]
#   (optional) Enable elevated access for users with service role belonging
#   to the 'rbac_service_project_name' project when using the default policy.
#   Defaults to $facts['os_service_default']
#
# [*rbac_service_project_name*]
#   (optional) The project name utilized for Role Based Access Control checks
#   for the reserved `service` project.
#   Defaults to 'services'
#
class ironic (
  Boolean $enabled                    = true,
  $package_ensure                     = 'present',
  $host                               = $facts['os_service_default'],
  $my_ip                              = $facts['os_service_default'],
  $my_ipv6                            = $facts['os_service_default'],
  $auth_strategy                      = 'keystone',
  $default_resource_class             = $facts['os_service_default'],
  $control_exchange                   = $facts['os_service_default'],
  $executor_thread_pool_size          = $facts['os_service_default'],
  $rpc_response_timeout               = $facts['os_service_default'],
  $rpc_transport                      = $facts['os_service_default'],
  $default_transport_url              = $facts['os_service_default'],
  $rabbit_use_ssl                     = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold = $facts['os_service_default'],
  $rabbit_heartbeat_rate              = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread        = $facts['os_service_default'],
  $rabbit_ha_queues                   = $facts['os_service_default'],
  $rabbit_quorum_queue                = $facts['os_service_default'],
  $rabbit_transient_quorum_queue      = $facts['os_service_default'],
  $rabbit_quorum_delivery_limit       = $facts['os_service_default'],
  $rabbit_quorum_max_memory_length    = $facts['os_service_default'],
  $rabbit_quorum_max_memory_bytes     = $facts['os_service_default'],
  $kombu_ssl_ca_certs                 = $facts['os_service_default'],
  $kombu_ssl_certfile                 = $facts['os_service_default'],
  $kombu_ssl_keyfile                  = $facts['os_service_default'],
  $kombu_ssl_version                  = $facts['os_service_default'],
  $kombu_reconnect_delay              = $facts['os_service_default'],
  $kombu_failover_strategy            = $facts['os_service_default'],
  $kombu_compression                  = $facts['os_service_default'],
  $amqp_durable_queues                = $facts['os_service_default'],
  Boolean $sync_db                    = true,
  Boolean $db_online_data_migrations  = false,
  Boolean $purge_config               = false,
  $notification_transport_url         = $facts['os_service_default'],
  $notification_driver                = $facts['os_service_default'],
  $notification_topics                = $facts['os_service_default'],
  $notification_level                 = $facts['os_service_default'],
  $versioned_notifications_topics     = $facts['os_service_default'],
  $rbac_service_role_elevated_access  = $facts['os_service_default'],
  $rbac_service_project_name          = 'services',
) {

  include ironic::deps
  include ironic::db
  include ironic::params

  include ironic::glance
  include ironic::neutron

  ensure_resource( 'package', 'ironic-common', {
    ensure => $package_ensure,
    name   => $::ironic::params::common_package_name,
    tag    => ['openstack', 'ironic-package'],
  })

  package { 'ironic-lib':
    ensure => $package_ensure,
    name   => $::ironic::params::lib_package_name,
    tag    => ['openstack', 'ironic-package'],
  }

  resources { 'ironic_config':
    purge => $purge_config,
  }

  ironic_config {
    'DEFAULT/auth_strategy':                     value => $auth_strategy;
    'DEFAULT/host':                              value => $host;
    'DEFAULT/my_ip':                             value => $my_ip;
    'DEFAULT/my_ipv6':                           value => $my_ipv6;
    'DEFAULT/default_resource_class':            value => $default_resource_class;
    'DEFAULT/notification_level':                value => $notification_level;
    'DEFAULT/versioned_notifications_topics':    value => $versioned_notifications_topics;
    'DEFAULT/rpc_transport':                     value => $rpc_transport;
    'DEFAULT/rbac_service_role_elevated_access': value => $rbac_service_role_elevated_access;
    'DEFAULT/rbac_service_project_name':         value => $rbac_service_project_name;
  }

  if $sync_db {
    include ironic::db::sync
  }

  if $db_online_data_migrations {
    include ironic::db::online_data_migrations
  }

  oslo::messaging::default {'ironic_config':
    executor_thread_pool_size => $executor_thread_pool_size,
    transport_url             => $default_transport_url,
    rpc_response_timeout      => $rpc_response_timeout,
    control_exchange          => $control_exchange,
  }

  oslo::messaging::rabbit {'ironic_config':
    rabbit_use_ssl                  => $rabbit_use_ssl,
    heartbeat_timeout_threshold     => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate                  => $rabbit_heartbeat_rate,
    heartbeat_in_pthread            => $rabbit_heartbeat_in_pthread,
    kombu_reconnect_delay           => $kombu_reconnect_delay,
    kombu_failover_strategy         => $kombu_failover_strategy,
    amqp_durable_queues             => $amqp_durable_queues,
    kombu_compression               => $kombu_compression,
    kombu_ssl_ca_certs              => $kombu_ssl_ca_certs,
    kombu_ssl_certfile              => $kombu_ssl_certfile,
    kombu_ssl_keyfile               => $kombu_ssl_keyfile,
    kombu_ssl_version               => $kombu_ssl_version,
    rabbit_ha_queues                => $rabbit_ha_queues,
    rabbit_quorum_queue             => $rabbit_quorum_queue,
    rabbit_transient_quorum_queue   => $rabbit_transient_quorum_queue,
    rabbit_quorum_delivery_limit    => $rabbit_quorum_delivery_limit,
    rabbit_quorum_max_memory_length => $rabbit_quorum_max_memory_length,
    rabbit_quorum_max_memory_bytes  => $rabbit_quorum_max_memory_bytes,
  }

  oslo::messaging::notifications { 'ironic_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }
}
