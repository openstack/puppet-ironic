#
# Copyright (C) 2016 Red Hat, Inc.
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

# Set up PXE boot for Ironic
#
# === Parameters
#
# [*package_ensure*]
#   (optional) Control the ensure parameter for the package resource
#   Defaults to 'present'
#
# [*tftp_root*]
#   (optional) Folder location to deploy PXE boot files
#   Defaults to '/tftpboot'
#
# [*http_root*]
#   (optional) Folder location to deploy HTTP PXE boot
#   Defaults to '/httpboot'
#
# [*http_port*]
#   (optional) port used by the HTTP service serving introspection and
#   deployment images.
#   Defaults to '8088'
#
# [*syslinux_path*]
#   (optional) Path to directory containing syslinux files.
#   Setting this to False will skip syslinux related resources.
#   Defaults to '$::ironic::params::syslinux_path'
#
# [*syslinux_files*]
#   (optional) Array of PXE boot files to copy from $syslinux_path to $tftp_root.
#   Defaults to '$::ironic::params::syslinux_files'
#
# [*tftp_bind_host*]
#   (optional) The IP address xinetd will listen on for TFTP.
#   Defaults to undef (listen on all ip addresses).
#
class ironic::pxe (
  $package_ensure = 'present',
  $tftp_root      = '/tftpboot',
  $http_root      = '/httpboot',
  $http_port      = '8088',
  $syslinux_path  = $::ironic::params::syslinux_path,
  $syslinux_files = $::ironic::params::syslinux_files,
  $tftp_bind_host = undef,
) inherits ::ironic::params {

  include ::ironic::deps
  include ::ironic::pxe::common

  $tftp_root_real = pick($::ironic::pxe::common::tftp_root, $tftp_root)
  $http_root_real = pick($::ironic::pxe::common::http_root, $http_root)
  $http_port_real = pick($::ironic::pxe::common::http_port, $http_port)

  file { $tftp_root_real:
    ensure  => 'directory',
    seltype => 'tftpdir_t',
    owner   => 'ironic',
    group   => 'ironic',
    require => Anchor['ironic::config::begin'],
    before  => Anchor['ironic::config::end'],
  }

  ensure_resource( 'package', 'ironic-common', {
      ensure => $package_ensure,
      name   => $::ironic::params::common_package_name,
      tag    => ['openstack', 'ironic-package'],})

  file { "${tftp_root_real}/pxelinux.cfg":
    ensure  => 'directory',
    seltype => 'tftpdir_t',
    owner   => 'ironic',
    group   => 'ironic',
    require => Anchor['ironic::install::end'],
  }

  file { $http_root_real:
    ensure  => 'directory',
    seltype => 'httpd_sys_content_t',
    owner   => 'ironic',
    group   => 'ironic',
    require => Anchor['ironic::config::begin'],
    before  => Anchor['ironic::config::end'],
  }

  ensure_resource( 'package', 'tftp-server', {
    'ensure' => $package_ensure,
    'name'   => $::ironic::params::tftpd_package,
    'tag'    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
  })

  $options = "--map-file ${tftp_root_real}/map-file"
  include ::xinetd

  xinetd::service { 'tftp':
    port        => '69',
    bind        => $tftp_bind_host,
    protocol    => 'udp',
    server_args => "${options} ${tftp_root_real}",
    server      => '/usr/sbin/in.tftpd',
    socket_type => 'dgram',
    cps         => '100 2',
    per_source  => '11',
    wait        => 'yes',
    subscribe   => Anchor['ironic::install::end'],
  }

  file { "${tftp_root_real}/map-file":
    ensure  => 'present',
    content => "r ^([^/]) ${tftp_root_real}/\\1",
  }

  if $syslinux_path {
    ensure_resource( 'package', 'syslinux', {
      ensure => $package_ensure,
      name   => $::ironic::params::syslinux_package,
      tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
    })

    ironic::pxe::tftpboot_file { $syslinux_files:
      source_directory      => $syslinux_path,
      destination_directory => $tftp_root_real,
      require               => Anchor['ironic-inspector::install::end'],
    }
  }

  ensure_resource( 'package', 'ipxe', {
    ensure => $package_ensure,
    name   => $::ironic::params::ipxe_package,
    tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
  })

  file { "${tftp_root_real}/undionly.kpxe":
    ensure  => 'present',
    seltype => 'tftpdir_t',
    owner   => 'ironic',
    group   => 'ironic',
    mode    => '0744',
    source  => "${::ironic::params::ipxe_rom_dir}/undionly.kpxe",
    backup  => false,
    require => Anchor['ironic-inspector::install::end'],
  }

  file { "${tftp_root_real}/ipxe.efi":
    ensure  => 'present',
    seltype => 'tftpdir_t',
    owner   => 'ironic',
    group   => 'ironic',
    mode    => '0744',
    source  => "${::ironic::params::ipxe_rom_dir}/ipxe.efi",
    backup  => false,
    require => Anchor['ironic-inspector::install::end'],
  }

  include ::apache

  apache::vhost { 'ipxe_vhost':
    priority   => '10',
    options    => ['Indexes','FollowSymLinks'],
    docroot    => $http_root_real,
    port       => $http_port_real,
    # FIXME: for backwards compatibility we have to add listen to the ipxe vhost
    add_listen => false,
  }
  # FIXME: this can be removed after ipxe element is removed from instack-undercloud
  concat::fragment { 'ipxe_vhost-listen':
    target  => '10-ipxe_vhost.conf',
    order   => 1337,
    content => "Listen ${http_port_real}",
  }
}
