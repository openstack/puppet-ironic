#
# Copyright (C) 2015 Red Hat, Inc.
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

# Configure the ironic-inspector auxiliary service to Ironic
#
# === Parameters
#
# [*package_ensure*]
#   (optional) Control the ensure parameter for the package resource
#   Defaults to 'present'
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*enabled*]
#   (optional) Define if the service must be enabled or not
#   Defaults to true
#
# [*listen_address*]
#   (optional) The listen IP for the Ironic-inspector API server.
#   Should be an valid IP address
#   Defaults to $facts['os_service_default'].
#
# [*pxe_transfer_protocol*]
#  (optional) Protocol preferred for transferring the ramdisk.
#  Some architecture require tftp is used exclusively.
#  Defaults to 'tftp'. Valid values are 'tftp' or 'http'.
#
# [*dhcp_debug*]
#   (optional) Boolean to enable dnsmasq debug logging.
#   Defaults to false
#
# [*auth_strategy*]
#   (optional) API authentication strategy: keystone or noauth
#   Defaults to 'keystone'
#
# [*timeout*]
#   (optional) Timeout after which introspection is considered failed,
#   set to 0 to disable.
#   Defaults to $facts['os_service_default']
#
# [*api_max_limit*]
#   (optional) Limit the number of elements an API list-call returns
#   Defaults to $facts['os_service_default']
#
# [*dnsmasq_interface*]
#   (optional) The interface for the ironic-inspector dnsmasq process
#   to listen on
#   Defaults to 'br-ctlplane'
#
# [*ramdisk_logs_dir*]
#   (optional) Location to store logs retrieved from the ramdisk
#   Defaults to '/var/log/ironic-inspector/ramdisk/'
#
# [*always_store_ramdisk_logs*]
#   (optional) Whether to store ramdisk logs even for successful introspection.
#   Defaults to $facts['os_service_default']
#
# [*add_ports*]
#   (optional)  Which MAC addresses to add as ports during introspection.
#   Allowed values: all, active, pxe.
#   Defaults to $facts['os_service_default']
#
# [*keep_ports*]
#   (optional) Which ports to keep after introspection
#   Defaults to $facts['os_service_default']
#
# [*store_data*]
#   (optional) Method for storing introspection data
#   Defaults to $facts['os_service_default']
#
# [*dnsmasq_ip_subnets*]
#    (optional) List of hashes with keys: 'tag', 'ip_range', 'netmask',
#    'gateway' and 'classless_static_routes'. 'ip_range' is the only required
#    key. Assigning multiple tagged subnets allow dnsmasq to serve dhcp request
#    that came in via dhcp relay/helper.
#    Example:
#    [{'ip_range' => '192.168.0.100,192.168.0.120', 'mtu' => '1500'},
#     {'tag'      => 'subnet1',
#      'ip_range' => '192.168.1.100,192.168.1.200',
#      'netmask'  => '255.255.255.0',
#      'gateway'  => '192.168.1.254'},
#     {'tag'                     => 'subnet2',
#      'ip_range'                => '192.168.2.100,192.168.2.200',
#      'netmask'                 => '255.255.255.0',
#      'gateway'                 => '192.168.2.254',
#      'classless_static_routes' => [{'destination' => '1.2.3.0/24',
#                                     'nexthop'     => '192.168.2.1'},
#                                    {'destination' => '4.5.6.0/24',
#                                     'nexthop'     => '192.168.2.1'}]}]
#    Defaults to []
#
# [*dnsmasq_local_ip*]
#   (optional) IP interface for the dnsmasq process
#   Defaults to '192.168.0.1'
#
# [*dnsmasq_dhcp_sequential_ip*]
#   (optional) When true enable the 'dhcp-sequential-ip' option for dnsmasq.
#   Defaults to true
#
# [*dnsmasq_dhcp_hostsdir*]
#   (optional) directory with DHCP hosts, only used with the "dnsmasq" PXE
#   filter.
#   Defaults to undef
#
# [*dnsmasq_log_facility*]
#   (optional) Log facility of the dnsmasq process.
#   Defaults to undef
#
# [*sync_db*]
#   Enable dbsync
#   Defaults to true
#
# [*ramdisk_collectors*]
#   Comma-separated list of IPA inspection collectors
#   Defaults to undef
#
# [*additional_processing_hooks*]
#   Comma-separated list of processing hooks to append to the default list.
#   Defaults to undef
#
# [*ramdisk_kernel_args*]
#   String with kernel arguments to send to the ramdisk on boot.
#   Defaults to ''
#
# [*ramdisk_filename*]
#   The filename of ramdisk which is used in pxelinux_cfg/ipxelinux_cfg templates
#   Defaults to 'agent.ramdisk'
#
# [*kernel_filename*]
#   The filename of kernel which is used in pxelinux_cfg/ipxelinux_cfg templates
#   Defaults to 'agent.kernel'
#
# [*ipxe_timeout*]
#   (optional) ipxe timeout in second. Should be an integer.
#   Defaults to $facts['os_service_default']
#
# [*http_port*]
#   (optional) port used by the HTTP service serving introspection images.
#   Defaults to 8088.
#
# [*tftp_root*]
#   (optional) Folder location to deploy PXE boot files
#   Defaults to '/tftpboot'
#
# [*http_root*]
#   (optional) Folder location to deploy HTTP PXE boot
#   Defaults to '/httpboot'
#
# [*detect_boot_mode*]
#   (optional) Whether to store the boot mode (BIOS or UEFI).
#   Defaults to $facts['os_service_default']
#
# [*node_not_found_hook*]
#   (optional) Plugin to run when a node is not found during lookup.
#   For example, "enroll" hook can be used for node auto-discovery.
#   Defaults to $facts['os_service_default']
#
# [*discovery_default_driver*]
#   (optional) The default driver to use for auto-discovered nodes.
#   Requires node_not_found_hook set to "enroll".
#   Defaults to $facts['os_service_default']
#
# [*enable_ppc64le*]
#   (optional) Boolean value to determine if ppc64le support should be enabled
#   Defaults to false (no ppc64le support)
#
# [*port_physnet_cidr_map*]
#   (optional) Hash where key's are CIDR and values are physical network.
#   Mapping of IP subnet CIDR to physical network. When the
#   physnet_cidr_map processing hook is enabled the physical_network property
#   of baremetal ports is populated based on this mapping.
#   Example: {'10.10.10.0/24' => 'physnet_a', '2001:db8::/64' => 'physnet_b'}
#   Defaults to {}
#
# [*uefi_ipxe_bootfile_name*]
#   (optional) Name of efi file used to boot servers with iPXE + UEFI. This
#   should be consistent with the uefi_ipxe_bootfile_name parameter in pxe
#   driver.
#   Defaults to $::ironic::parmas::uefi_ipxe_bootfile_name
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
#    Defaults to 'fake://'
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
# [*standalone*]
#   (optional) Whether to run ironic-inspector as a standalone service.
#   Defaults to false
#
class ironic::inspector (
  $package_ensure                             = 'present',
  Boolean $manage_service                     = true,
  Boolean $enabled                            = true,
  $listen_address                             = $facts['os_service_default'],
  Enum['http', 'tftp'] $pxe_transfer_protocol = 'tftp',
  Boolean $dhcp_debug                         = false,
  $auth_strategy                              = 'keystone',
  $timeout                                    = $facts['os_service_default'],
  $api_max_limit                              = $facts['os_service_default'],
  $dnsmasq_interface                          = 'br-ctlplane',
  $ramdisk_logs_dir                           = '/var/log/ironic-inspector/ramdisk/',
  $always_store_ramdisk_logs                  = $facts['os_service_default'],
  $add_ports                                  = $facts['os_service_default'],
  $keep_ports                                 = $facts['os_service_default'],
  $store_data                                 = $facts['os_service_default'],
  Array[Hash] $dnsmasq_ip_subnets             = [],
  $dnsmasq_local_ip                           = '192.168.0.1',
  Boolean $dnsmasq_dhcp_sequential_ip         = true,
  $dnsmasq_dhcp_hostsdir                      = undef,
  $dnsmasq_log_facility                       = undef,
  Boolean $sync_db                            = true,
  Optional[String[1]] $ramdisk_collectors     = undef,
  String[1] $ramdisk_filename                 = 'agent.ramdisk',
  String[1] $kernel_filename                  = 'agent.kernel',
  $additional_processing_hooks                = undef,
  String $ramdisk_kernel_args                 = '',
  $ipxe_timeout                               = $facts['os_service_default'],
  $http_port                                  = '8088',
  $detect_boot_mode                           = $facts['os_service_default'],
  $tftp_root                                  = '/tftpboot',
  $http_root                                  = '/httpboot',
  $node_not_found_hook                        = $facts['os_service_default'],
  $discovery_default_driver                   = $facts['os_service_default'],
  Boolean $enable_ppc64le                     = false,
  Hash $port_physnet_cidr_map                 = {},
  $uefi_ipxe_bootfile_name                    = $::ironic::params::uefi_ipxe_bootfile_name,
  $control_exchange                           = $facts['os_service_default'],
  $executor_thread_pool_size                  = $facts['os_service_default'],
  $rpc_response_timeout                       = $facts['os_service_default'],
  $rpc_transport                              = $facts['os_service_default'],
  $default_transport_url                      = 'fake://',
  $rabbit_use_ssl                             = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold         = $facts['os_service_default'],
  $rabbit_heartbeat_rate                      = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread                = $facts['os_service_default'],
  $rabbit_ha_queues                           = $facts['os_service_default'],
  $rabbit_quorum_queue                        = $facts['os_service_default'],
  $rabbit_quorum_delivery_limit               = $facts['os_service_default'],
  $rabbit_quorum_max_memory_length            = $facts['os_service_default'],
  $rabbit_quorum_max_memory_bytes             = $facts['os_service_default'],
  $kombu_ssl_ca_certs                         = $facts['os_service_default'],
  $kombu_ssl_certfile                         = $facts['os_service_default'],
  $kombu_ssl_keyfile                          = $facts['os_service_default'],
  $kombu_ssl_version                          = $facts['os_service_default'],
  $kombu_reconnect_delay                      = $facts['os_service_default'],
  $kombu_failover_strategy                    = $facts['os_service_default'],
  $kombu_compression                          = $facts['os_service_default'],
  $amqp_durable_queues                        = $facts['os_service_default'],
  Boolean $standalone                         = true,
) inherits ironic::params {

  include ironic::deps
  include ironic::pxe::common
  include ironic::inspector::db
  include ironic::inspector::policy

  if $auth_strategy == 'keystone' {
    include ironic::inspector::authtoken
  }

  if !standalone and $facts['os']['family'] != 'RedHat' {
    fail('Non-standalone mode configuration is not supported in this operating system')
  }

  $tftp_root_real               = pick($::ironic::pxe::common::tftp_root, $tftp_root)
  $http_root_real               = pick($::ironic::pxe::common::http_root, $http_root)
  $http_port_real               = pick($::ironic::pxe::common::http_port, $http_port)
  $ipxe_timeout_real            = pick($::ironic::pxe::common::ipxe_timeout, $ipxe_timeout)
  $uefi_ipxe_bootfile_name_real = pick($::ironic::pxe::common::uefi_ipxe_bootfile_name, $uefi_ipxe_bootfile_name)

  $dnsmasq_local_ip_real = normalize_ip_for_uri($dnsmasq_local_ip)
  $dnsmasq_ip_subnets_real = ipv6_normalize_dnsmasq_ip_subnets($dnsmasq_ip_subnets)

  if $pxe_transfer_protocol == 'tftp' {
    file { '/etc/ironic-inspector/dnsmasq.conf':
      ensure  => 'present',
      content => template('ironic/inspector_dnsmasq_tftp.erb'),
      tag     => 'ironic-inspector-dnsmasq-file',
    }
    file { "${tftp_root_real}/pxelinux.cfg/default":
      ensure  => 'present',
      seltype => 'tftpdir_t',
      owner   => $::ironic::params::inspector_user,
      group   => $::ironic::params::inspector_group,
      content => template('ironic/inspector_pxelinux_cfg.erb'),
      tag     => 'ironic-inspector-dnsmasq-file',
    }
  }

  if $pxe_transfer_protocol == 'http' {
    file { '/etc/ironic-inspector/dnsmasq.conf':
      ensure  => 'present',
      content => template('ironic/inspector_dnsmasq_http.erb'),
      tag     => 'ironic-inspector-dnsmasq-file',
    }
    file { "${http_root_real}/inspector.ipxe":
      ensure  => 'present',
      seltype => 'httpd_sys_content_t',
      owner   => $::ironic::params::inspector_user,
      group   => $::ironic::params::inspector_group,
      content => template('ironic/inspector_ipxe.erb'),
      tag     => 'ironic-inspector-dnsmasq-file',
    }
  }

  # NOTE: ppc64le hardware supports only tftp
  if $enable_ppc64le {
    file { "${tftp_root_real}/ppc64le":
      ensure  => 'directory',
      seltype => 'tftpdir_t',
      owner   => $::ironic::params::inspector_user,
      group   => $::ironic::params::inspector_group,
      tag     => 'ironic-inspector-dnsmasq-file',
    }
    file { "${tftp_root_real}/ppc64le/default":
      ensure  => 'present',
      seltype => 'tftpdir_t',
      owner   => $::ironic::params::inspector_user,
      group   => $::ironic::params::inspector_group,
      content => template('ironic/inspector_pxelinux_cfg.erb'),
      tag     => 'ironic-inspector-dnsmasq-file',
    }
  }

  Anchor['ironic-inspector::config::begin']
  -> File<| tag == 'ironic-inspector-dnsmasq-file' |>
  -> Anchor['ironic-inspector::config::end']

  # Configure inspector.conf

  #Processing hooks string
  #Moved here in favor of removing the
  #140 chars exceeded error in puppet-lint
  $p_hooks = join(delete_undef_values(['$default_processing_hooks', $additional_processing_hooks]), ',')

  # Convert the hash to comma separated string of <key>:<value> pairs.
  $port_physnet_cidr_map_real = join($port_physnet_cidr_map.map | $i | { join($i, ':') }, ',')

  ironic_inspector_config {
    'DEFAULT/listen_address':                     value => $listen_address;
    'DEFAULT/auth_strategy':                      value => $auth_strategy;
    'DEFAULT/timeout':                            value => $timeout;
    'DEFAULT/api_max_limit':                      value => $api_max_limit;
    'capabilities/boot_mode':                     value => $detect_boot_mode;
    'iptables/dnsmasq_interface':                 value => $dnsmasq_interface;
    'processing/ramdisk_logs_dir':                value => $ramdisk_logs_dir;
    'processing/always_store_ramdisk_logs':       value => $always_store_ramdisk_logs;
    'processing/add_ports':                       value => $add_ports;
    'processing/keep_ports':                      value => $keep_ports;
    'processing/store_data':                      value => $store_data;
    # Here we use oslo.config interpolation with another option default_processing_hooks,
    # which we don't change as it might break introspection completely.
    'processing/processing_hooks':                value => $p_hooks;
    'processing/node_not_found_hook':             value => $node_not_found_hook;
    'discovery/enroll_node_driver':               value => $discovery_default_driver;
    'port_physnet/cidr_map':                      value => $port_physnet_cidr_map_real;
    'DEFAULT/standalone':                         value => $standalone;
  }

  oslo::messaging::default {'ironic_inspector_config':
    executor_thread_pool_size => $executor_thread_pool_size,
    transport_url             => $default_transport_url,
    rpc_response_timeout      => $rpc_response_timeout,
    control_exchange          => $control_exchange,
  }

  oslo::messaging::rabbit {'ironic_inspector_config':
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
    rabbit_quorum_delivery_limit    => $rabbit_quorum_delivery_limit,
    rabbit_quorum_max_memory_length => $rabbit_quorum_max_memory_length,
    rabbit_quorum_max_memory_bytes  => $rabbit_quorum_max_memory_bytes,
  }

  if $dnsmasq_interface != 'br-ctlplane' {
    warning("The [pxe] dnsmasq_interface option may not be configured by this class \
in a future release. Make sure the ironic::inspector::pxe_filter::iptables class is \
included in the manifest")
  }

  # Install package
  package { 'ironic-inspector':
    ensure => $package_ensure,
    name   => $::ironic::params::inspector_package,
    tag    => ['openstack', 'ironic-inspector-package'],
  }

  if ! $standalone {
    package { 'ironic-inspector-api':
      ensure => $package_ensure,
      name   => $::ironic::params::inspector_api_package,
      tag    => ['openstack', 'ironic-inspector-package'],
    }
    package { 'ironic-inspector-conductor':
      ensure => $package_ensure,
      name   => $::ironic::params::inspector_conductor_package,
      tag    => ['openstack', 'ironic-inspector-package'],
    }
  }

  if $::ironic::params::inspector_dnsmasq_package {
    package { 'ironic-inspector-dnsmasq':
      ensure => $package_ensure,
      name   => $::ironic::params::inspector_dnsmasq_package,
      tag    => ['openstack', 'ironic-inspector-package'],
    }
  }

  if $sync_db {
    include ironic::inspector::db::sync
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }

    if $standalone {
      service { 'ironic-inspector':
        ensure    => $ensure,
        name      => $::ironic::params::inspector_service,
        enable    => $enabled,
        hasstatus => true,
        tag       => 'ironic-inspector-service',
      }
      Keystone_endpoint<||> -> Service['ironic-inspector']
    } else {

      # NOTE(tkajinam): Ensure ironic-inspector is stopped before starting
      #                 -api and -conductor.
      service { 'ironic-inspector':
        ensure    => 'stopped',
        name      => $::ironic::params::inspector_service,
        enable    => false,
        hasstatus => true,
        tag       => 'ironic-inspector-service',
      }
      Service['ironic-inspector'] -> Service['ironic-inspector-conductor']
      Service <| title == 'httpd' |> { tag +> 'ironic-inspector-service' }

      service { 'ironic-inspector-conductor':
        ensure    => $ensure,
        name      => $::ironic::params::inspector_conductor_service,
        enable    => $enabled,
        hasstatus => true,
        tag       => 'ironic-inspector-service',
      }
      Keystone_endpoint<||> -> Service['ironic-inspector-conductor']
    }

    if $::ironic::params::inspector_dnsmasq_service {
      service { 'ironic-inspector-dnsmasq':
        ensure    => $ensure,
        name      => $::ironic::params::inspector_dnsmasq_service,
        enable    => $enabled,
        hasstatus => true,
        tag       => 'ironic-inspector-dnsmasq-service',
        subscribe => File['/etc/ironic-inspector/dnsmasq.conf'],
      }
    } else {
      warning("The ironic-inspector-dnsmasq service is not available. \
Please set up the dnsmasq service additionally.")
    }
  }
}
