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
# [*pxe_transfer_protocol*]
#  (optional) Protocol to be used for transferring the ramdisk
#  Defaults to 'tftp'. Valid values are 'tftp' or 'http'.
#
# [*debug*]
#   (optional) Enable debug logging
#   Defaults to false
#
# [*auth_uri*]
#   (optional) Complete public Identity API endpoint
#   Defaults to 'http://127.0.0.1:5000/v2.0'
#
# [*identity_uri*]
#   (optional) Complete admin Identity API endpoint
#   Defaults to 'http://127.0.0.1:35357'
#
# [*admin_user*]
#   (optional) The name of the auth user
#   Defaults to 'ironic'
#
# [*admin_password*]
#   (optional) The password to use for authentication (keystone)
#   Defaults to undef. Set a value unless you are using noauth
#
# [*admin_tenant_name*]
#   (optional) The tenant of the auth user
#   Defaults to 'services'
#
# [*dnsmasq_interface*]
#   (optional) The interface for the ironic-inspector dnsmasq process
#   to listen on
#   Defaults to 'br-ctlplane'
#
# [*db_connection*]
#   (optional) Location of the ironic-inspector node cache database
#   Defaults to 'sqlite::////var/lib/ironic-inspector/inspector.sqlite'
#
# [*ramdisk_logs_dir*]
#   (optional) Location to store logs retrieved from the ramdisk
#   Defaults to '/var/log/ironic-inspector/ramdisk/'
#
# [*enable_setting_ipmi_credentials*]
#   (optional) Enable setting of IPMI credentials
#   Defaults to false
#
# [*keep_ports*]
#   (optional) Which ports to keep after introspection
#   Defaults to 'all'
#
# [*store_data*]
#   (optional) Method for storing introspection data
#   Defaults to 'none'
#
# [*ironic_username*]
#   (optional) User name for accessing Ironic API
#   Defaults to 'ironic'
#
# [*ironic_password*]
#   (optional) Password for accessing Ironic API
#   Defaults to undef. Set a value unless using noauth.
#
# [*ironic_tenant_name*]
#   (optional) Tenant name for accessing Ironic API
#   Defaults to 'services'
#
# [*ironic_auth_url*]
#   (optional) Keystone authentication URL for Ironic
#   Defautls to 'http://127.0.0.1:5000/v2.0'
#
# [*ironic_max_retries*]
#   (optional) Maximum number of retries in case of conflict error
#   Defaults to 30
#
# [*ironic_retry_interval*]
#   (optional) Interval between retries in case of conflict error
#   Defaults to 2
#
# [*swift_username*]
#   (optional) User name for accessing Swift API
#   Defaults to 'ironic'
#
# [*swift_password*]
#   (optional) Password for accessing Swift API
#   Defaults to undef. Set a value if using Swift.
#
# [*swift_tenant_name*]
#   (optional) Tenant name for accessing Swift API
#   Defaults to 'services'
#
# [*swift_auth_url*]
#   (optional) Keystone authentication URL for Swift
#   Defautls to 'http://127.0.0.1:5000/v2.0'
#
# [*dnsmasq_ip_range*]
#   (optional) IP range to use for nodes being introspected
#   Defaults to '192.168.0.100,192.168.0.120'
#
# [*dnsmasq_local_ip*]
#   (optional) IP interface for the dnsmasq process
#   Defaults to '192.168.0.1'
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
class ironic::inspector (
  $package_ensure                  = 'present',
  $enabled                         = true,
  $pxe_transfer_protocol           = 'tftp',
  $debug                           = false,
  $auth_uri                        = 'http://127.0.0.1:5000/v2.0',
  $identity_uri                    = 'http://127.0.0.1:35357',
  $admin_user                      = 'ironic',
  $admin_password                  = undef,
  $admin_tenant_name               = 'services',
  $dnsmasq_interface               = 'br-ctlplane',
  $db_connection                   = 'sqlite:////var/lib/ironic-inspector/inspector.sqlite',
  $ramdisk_logs_dir                = '/var/log/ironic-inspector/ramdisk/',
  $enable_setting_ipmi_credentials = false,
  $keep_ports                      = 'all',
  $store_data                      = 'none',
  $ironic_username                 = 'ironic',
  $ironic_password                 = undef,
  $ironic_tenant_name              = 'services',
  $ironic_auth_url                 = 'http://127.0.0.1:5000/v2.0',
  $ironic_max_retries              = 30,
  $ironic_retry_interval           = 2,
  $swift_username                  = 'ironic',
  $swift_password                  = undef,
  $swift_tenant_name               = 'services',
  $swift_auth_url                  = 'http://127.0.0.1:5000/v2.0',
  $dnsmasq_ip_range                = '192.168.0.100,192.168.0.120',
  $dnsmasq_local_ip                = '192.168.0.1',
  $sync_db                         = true,
  $ramdisk_collectors              = 'default',
  $additional_processing_hooks     = undef,
  $ramdisk_kernel_args             = undef,
) {

  include ::ironic::params

  Ironic_inspector_config<||> ~> Service['ironic-inspector']

  file { '/etc/ironic-inspector/inspector.conf':
    ensure  => 'present',
    require => Package['ironic-inspector'],
  }
  file { '/tftpboot':
    ensure  => 'directory',
    seltype => 'tftpdir_t',
  }

  if $pxe_transfer_protocol == 'tftp' {
    file { '/etc/ironic-inspector/dnsmasq.conf':
      ensure  => 'present',
      content => template('ironic/inspector_dnsmasq_tftp.erb'),
      require => Package['ironic-inspector'],
    }
    file { '/tftpboot/pxelinux.cfg':
      ensure => 'directory',
    }
    file { '/tftpboot/pxelinux.cfg/default':
      ensure  => 'present',
      content => template('ironic/inspector_pxelinux_cfg.erb'),
      require => Package['ironic-inspector'],
    }
  }

  if $pxe_transfer_protocol == 'http' {
    file { '/etc/ironic-inspector/dnsmasq.conf':
      ensure  => 'present',
      content => template('ironic/inspector_dnsmasq_http.erb'),
      require => Package['ironic-inspector'],
    }
    file { '/httpboot':
      ensure => 'directory',
    }
    file { '/httpboot/inspector.ipxe':
      ensure  => 'present',
      content => template('ironic/inspector_ipxe.erb'),
      require => Package['ironic-inspector'],
    }
  }

  # Configure inspector.conf
  ironic_inspector_config {
    'DEFAULT/debug':                              value => $debug;
    'keystone_authtoken/auth_uri':                value => $auth_uri;
    'keystone_authtoken/identity_uri':            value => $identity_uri;
    'keystone_authtoken/admin_user':              value => $admin_user;
    'keystone_authtoken/admin_password':          value => $admin_password, secret => true;
    'keystone_authtoken/admin_tenant_name':       value => $admin_tenant_name;
    'firewall/dnsmasq_interface':                 value => $dnsmasq_interface;
    'database/connection':                        value => $db_connection;
    'processing/ramdisk_logs_dir':                value => $ramdisk_logs_dir;
    'processing/enable_setting_ipmi_credentials': value => $enable_setting_ipmi_credentials;
    'processing/keep_ports':                      value => $keep_ports;
    'processing/store_data':                      value => $store_data;
    'ironic/os_username':                         value => $ironic_username;
    'ironic/os_password':                         value => $ironic_password, secret => true;
    'ironic/os_tenant_name':                      value => $ironic_tenant_name;
    'ironic/os_auth_url':                         value => $ironic_auth_url;
    'ironic/max_retries':                         value => $ironic_max_retries;
    'ironic/retry_interval':                      value => $ironic_retry_interval;
    'swift/username':                             value => $swift_username;
    'swift/password':                             value => $swift_password, secret => true;
    'swift/tenant_name':                          value => $swift_tenant_name;
    'swift/os_auth_url':                          value => $swift_auth_url;
    # Here we use oslo.config interpolation with another option default_processing_hooks,
    # which we don't change as it might break introspection completely.
    'processing/processing_hooks':                value => join(delete_undef_values(['$default_processing_hooks', $additional_processing_hooks]), ',');
  }

  # Install package
  if $::ironic::params::inspector_package {
    Package['ironic-inspector'] -> Service['ironic-inspector']
    Package['ironic-inspector'] -> Service['ironic-inspector-dnsmasq']
    package { 'ironic-inspector':
      ensure => $package_ensure,
      name   => $::ironic::params::inspector_package,
      tag    => ['openstack', 'ironic-inspector-package'],
    }
  }

  if $sync_db {
    include ::ironic::db::inspector_sync
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

  Service['ironic-inspector'] -> Service['ironic-inspector-dnsmasq']
  service { 'ironic-inspector-dnsmasq':
    ensure    => $ensure,
    name      => $::ironic::params::inspector_dnsmasq_service,
    enable    => $enabled,
    hasstatus => true,
    tag       => 'ironic-inspector-dnsmasq-service',
  }

}
