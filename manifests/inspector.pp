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
# [*enabled*]
#   (optional) Define if the service must be enabled or not
#   Defaults to true
#
# [*listen_address*]
#   (optional) The listen IP for the Ironic-inspector API server.
#   Should be an valid IP address
#   Defaults to $::os_service_default.
#
# [*pxe_transfer_protocol*]
#  (optional) Protocol preferred for transferring the ramdisk.
#  Some archtecture require tftp is used exclusively.
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
#   Defaults to $::os_service_default
#
# [*api_max_limit*]
#   (optional) Limit the numer of elements an API list-call returns
#   Defaults to $::os_service_default
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
#   Defaults to $::os_service_default
#
# [*add_ports*]
#   (optional)  Which MAC addresses to add as ports during introspection.
#   Allowed values: all, active, pxe.
#   Defaults to $::os_service_default
#
# [*keep_ports*]
#   (optional) Which ports to keep after introspection
#   Defaults to 'all'
#
# [*store_data*]
#   (optional) Method for storing introspection data
#   Defaults to 'none'
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
# [*sync_db*]
#   Enable dbsync
#   Defaults to true
#
# [*ramdisk_collectors*]
#   Comma-separated list of IPA inspection collectors
#   Defaults to 'default'
#
# [*additional_processing_hooks*]
#   Comma-separated list of processing hooks to append to the default list.
#   Defaults to undef
#
# [*ramdisk_kernel_args*]
#   String with kernel arguments to send to the ramdisk on boot.
#   Defaults to undef
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
#   Defaults to $::os_service_default
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
#   Defaults to $::os_service_default
#
# [*node_not_found_hook*]
#   (optional) Plugin to run when a node is not found during lookup.
#   For example, "enroll" hook can be used for node auto-discovery.
#   Defaults to $::os_service_default
#
# [*discovery_default_driver*]
#   (optional) The default driver to use for auto-discovered nodes.
#   Requires node_not_found_hook set to "enroll".
#   Defaults to $::os_service_default
#
# [*enable_ppc64le*]
#   (optional) Boolean value to dtermine if ppc64le support should be enabled
#   Defaults to false (no ppc64le support)
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:F
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to 'fake://'
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
#   Defaults to 'snponly.efi'
#
# DEPRECATED PARAMETERS
#
# [*db_connection*]
#   (optional) Location of the ironic-inspector node cache database
#   Defaults to undef
#
class ironic::inspector (
  $package_ensure                  = 'present',
  $enabled                         = true,
  $listen_address                  = $::os_service_default,
  $pxe_transfer_protocol           = 'tftp',
  $dhcp_debug                      = false,
  $auth_strategy                   = 'keystone',
  $timeout                         = $::os_service_default,
  $api_max_limit                   = $::os_service_default,
  $dnsmasq_interface               = 'br-ctlplane',
  $ramdisk_logs_dir                = '/var/log/ironic-inspector/ramdisk/',
  $always_store_ramdisk_logs       = $::os_service_default,
  $add_ports                       = $::os_service_default,
  $keep_ports                      = 'all',
  $store_data                      = 'none',
  $dnsmasq_ip_subnets              = [],
  $dnsmasq_local_ip                = '192.168.0.1',
  $dnsmasq_dhcp_sequential_ip      = true,
  $dnsmasq_dhcp_hostsdir           = undef,
  $sync_db                         = true,
  $ramdisk_collectors              = 'default',
  $ramdisk_filename                = 'agent.ramdisk',
  $kernel_filename                 = 'agent.kernel',
  $additional_processing_hooks     = undef,
  $ramdisk_kernel_args             = undef,
  $ipxe_timeout                    = $::os_service_default,
  $http_port                       = '8088',
  $detect_boot_mode                = $::os_service_default,
  $tftp_root                       = '/tftpboot',
  $http_root                       = '/httpboot',
  $node_not_found_hook             = $::os_service_default,
  $discovery_default_driver        = $::os_service_default,
  $enable_ppc64le                  = false,
  $default_transport_url           = 'fake://',
  $port_physnet_cidr_map           = {},
  $uefi_ipxe_bootfile_name         = 'snponly.efi',
  # DEPRECATED PARAMETERS
  $db_connection                   = undef,
) {

  validate_legacy(Array, 'validate_array', $dnsmasq_ip_subnets)
  validate_legacy(Hash, 'validate_hash', $port_physnet_cidr_map)

  include ironic::deps
  include ironic::params
  include ironic::pxe::common
  include ironic::inspector::db
  include ironic::inspector::policy

  if $db_connection != undef {
    warning('The db_connection parameter is deprecated and will be removed \
in a future realse. Use ironic::inspector::db::database_connection instead')
  }

  if $auth_strategy == 'keystone' {
    include ironic::inspector::authtoken
  }

  $tftp_root_real               = pick($::ironic::pxe::common::tftp_root, $tftp_root)
  $http_root_real               = pick($::ironic::pxe::common::http_root, $http_root)
  $http_port_real               = pick($::ironic::pxe::common::http_port, $http_port)
  $ipxe_timeout_real            = pick($::ironic::pxe::common::ipxe_timeout, $ipxe_timeout)
  $uefi_ipxe_bootfile_name_real = pick($::ironic::pxe::common::uefi_ipxe_bootfile_name, $uefi_ipxe_bootfile_name)

  file { '/etc/ironic-inspector/inspector.conf':
    ensure  => 'present',
    owner   => 'ironic-inspector',
    group   => 'ironic-inspector',
    require => Anchor['ironic-inspector::config::begin'],
  }

  $dnsmasq_local_ip_real = normalize_ip_for_uri($dnsmasq_local_ip)
  $dnsmasq_ip_subnets_real = ipv6_normalize_dnsmasq_ip_subnets($dnsmasq_ip_subnets)

  if $pxe_transfer_protocol == 'tftp' {
    file { '/etc/ironic-inspector/dnsmasq.conf':
      ensure  => 'present',
      content => template('ironic/inspector_dnsmasq_tftp.erb'),
      require => Anchor['ironic-inspector::config::begin'],
    }
    file { "${tftp_root_real}/pxelinux.cfg/default":
      ensure  => 'present',
      seltype => 'tftpdir_t',
      owner   => 'ironic-inspector',
      group   => 'ironic-inspector',
      content => template('ironic/inspector_pxelinux_cfg.erb'),
      require => Anchor['ironic-inspector::config::begin'],
    }
  }

  if $pxe_transfer_protocol == 'http' {
    file { '/etc/ironic-inspector/dnsmasq.conf':
      ensure  => 'present',
      content => template('ironic/inspector_dnsmasq_http.erb'),
      require => Anchor['ironic-inspector::config::begin'],
    }
    file { "${http_root_real}/inspector.ipxe":
      ensure  => 'present',
      seltype => 'httpd_sys_content_t',
      owner   => 'ironic-inspector',
      group   => 'ironic-inspector',
      content => template('ironic/inspector_ipxe.erb'),
      require => Anchor['ironic-inspector::config::begin'],
    }
  }

  # NOTE: ppc64le hardware supports only tftp
  if $enable_ppc64le {
    file { "${tftp_root_real}/ppc64le":
      ensure  => 'directory',
      seltype => 'tftpdir_t',
      owner   => 'ironic-inspector',
      group   => 'ironic-inspector',
      require => Anchor['ironic-inspector::config::begin'],
    }
    file { "${tftp_root_real}/ppc64le/default":
      ensure  => 'present',
      seltype => 'tftpdir_t',
      owner   => 'ironic-inspector',
      group   => 'ironic-inspector',
      content => template('ironic/inspector_pxelinux_cfg.erb'),
      require => Anchor['ironic-inspector::config::begin'],
    }
  }

  # Configure inspector.conf

  #Processing hooks string
  #Moved here in favor of removing the
  #140 chars exeeded error in puppet-lint
  $p_hooks = join(delete_undef_values(['$default_processing_hooks', $additional_processing_hooks]), ',')

  # Convert the hash to comma separated string of <key>:<value> pairs.
  $port_physnet_cidr_map_real = join($port_physnet_cidr_map.map | $i | { join($i, ':') }, ',')

  ironic_inspector_config {
    'DEFAULT/listen_address':                     value => $listen_address;
    'DEFAULT/auth_strategy':                      value => $auth_strategy;
    'DEFAULT/timeout':                            value => $timeout;
    'DEFAULT/transport_url':                      value => $default_transport_url;
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
  }

  # Install package
  if $::ironic::params::inspector_package {
    package { 'ironic-inspector':
      ensure => $package_ensure,
      name   => $::ironic::params::inspector_package,
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

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  # Manage services
  service { 'ironic-inspector':
    ensure    => $ensure,
    name      => $::ironic::params::inspector_service,
    enable    => $enabled,
    hasstatus => true,
    tag       => 'ironic-inspector-service',
  }
  Keystone_endpoint<||> -> Service['ironic-inspector']

  service { 'ironic-inspector-dnsmasq':
    ensure    => $ensure,
    name      => $::ironic::params::inspector_dnsmasq_service,
    enable    => $enabled,
    hasstatus => true,
    tag       => 'ironic-inspector-dnsmasq-service',
    subscribe => File['/etc/ironic-inspector/dnsmasq.conf'],
  }

}
