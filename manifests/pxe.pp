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
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*enabled*]
#   (optional) Define if the service must be enabled or not.
#   Defaults to true.
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
#   Defaults to 8088
#
# [*pxelinux_path*]
#   (optional) Path to directory containing pxelinux.0 .
#   Setting this to False will skip syslinux related resources.
#   Defaults to '$ironic::params::pxelinux_path'
#
# [*syslinux_path*]
#   (optional) Path to directory containing syslinux files.
#   Setting this to False will skip syslinux related resources.
#   Defaults to '$ironic::params::syslinux_path'
#
# [*syslinux_files*]
#   (optional) Array of PXE boot files to copy from $syslinux_path to $tftp_root.
#   Defaults to '$ironic::params::syslinux_files'
#
# [*tftp_bind_host*]
#   (optional) The IP address TFTP server will listen on for TFTP.
#   Defaults to undef (listen on all ip addresses).
#
# [*ipxe_name_base*]
#   (optional) Beginning of the source file name which is copied to
#   $tftproot/ipxe.efi. Setting this to 'ipxe-snponly' on CentOS/RHEL would
#   results in the source file being /usr/share/ipxe/ipxe-snponly-x86_64.efi.
#   Defaults to $ironic::params::ipxe_name_base
#
# [*uefi_ipxe_bootfile_name*]
#   (optional) Name of efi file used to boot servers with iPXE + UEFI. This
#   should be consistent with the uefi_ipxe_bootfile_name parameter in pxe
#   driver.
#   Defaults to $ironic::params::uefi_ipxe_bootfile_name
#
# [*uefi_pxe_bootfile_name*]
#   (optional) Name of efi file used to boot servers with PXE + UEFI. This
#   should be consistent with the uefi_pxe_bootfile_name parameter in pxe
#   driver.
#   Defaults to $ironic::params::uefi_pxe_bootfile_name
#
# [*tftp_use_xinetd*]
#   (optional) Override wheter to use xinetd instead of dnsmasq as the tftp
#   service facilitator.
#   Defaults to ironic::params::xinetd_available
#
# [*dnsmasq_log_facility*]
#   (optional) Log facility of the dnsmasq process to server tftp server.
#   Defaults to undef
#
# [*manage_http_server*]
#   (optional) Set up Apache HTTP Server.
#   Defaults to true
#
# [*vhost_priority*]
#   (Optional) The priority for the vhost.
#   Defaults to 10
#
# [*vhost_options*]
#   (Optional) Set the options for the spefieid virtual host.
#   Defaults to ['-Indexes', '+FollowSymLinks']
#
# [*vhost_config*]
#   (Optional) Additional parameters passed to the apache::vhost defined type.
#   Defaults to {}
#
class ironic::pxe (
  Stdlib::Ensure::Package $package_ensure                         = 'present',
  Boolean $manage_service                                         = true,
  Boolean $enabled                                                = true,
  Stdlib::Absolutepath $tftp_root                                 = '/tftpboot',
  Stdlib::Absolutepath $http_root                                 = '/httpboot',
  $http_port                                                      = 8088,
  Optional[Variant[Stdlib::Absolutepath, Boolean]] $pxelinux_path = $ironic::params::pxelinux_path,
  Optional[Variant[Stdlib::Absolutepath, Boolean]] $syslinux_path = $ironic::params::syslinux_path,
  Optional[Array[String[1]]] $syslinux_files                      = $ironic::params::syslinux_files,
  $tftp_bind_host                                                 = undef,
  String[1] $ipxe_name_base                                       = $ironic::params::ipxe_name_base,
  String[1] $uefi_ipxe_bootfile_name                              = $ironic::params::uefi_ipxe_bootfile_name,
  String[1] $uefi_pxe_bootfile_name                               = $ironic::params::uefi_pxe_bootfile_name,
  Boolean $tftp_use_xinetd                                        = $ironic::params::xinetd_available,
  $dnsmasq_log_facility                                           = undef,
  Boolean $manage_http_server                                     = true,
  $vhost_priority                                                 = 10,
  Array[String] $vhost_options                                    = ['-Indexes', '+FollowSymLinks'],
  Hash $vhost_config                                              = {},
) inherits ironic::params {
  include ironic::deps
  include ironic::pxe::common

  $tftp_root_real = pick($ironic::pxe::common::tftp_root, $tftp_root)
  $http_root_real = pick($ironic::pxe::common::http_root, $http_root)
  $http_port_real = pick($ironic::pxe::common::http_port, $http_port)
  $uefi_ipxe_bootfile_name_real = pick($ironic::pxe::common::uefi_ipxe_bootfile_name, $uefi_ipxe_bootfile_name)
  $uefi_pxe_bootfile_name_real = pick($ironic::pxe::common::uefi_pxe_bootfile_name, $uefi_pxe_bootfile_name)

  if $facts['os']['family'] == 'RedHat' {
    $arch = "-${facts['os']['architecture']}"
  } else {
    $arch = ''
  }

  file { $tftp_root_real:
    ensure  => 'directory',
    seltype => 'tftpdir_t',
    owner   => $ironic::params::user,
    group   => $ironic::params::group,
    require => Anchor['ironic::config::begin'],
    before  => Anchor['ironic::config::end'],
  }

  # NOTE(tkajinam): ironic-common package is also installed by the base ironic
  #                 class so here we need ensure_resource
  ensure_resource( 'package', 'ironic-common', {
    ensure => $package_ensure,
    name   => $ironic::params::common_package_name,
    tag    => ['openstack', 'ironic-package'],
  })

  file { "${tftp_root_real}/pxelinux.cfg":
    ensure  => 'directory',
    seltype => 'tftpdir_t',
    owner   => $ironic::params::user,
    group   => $ironic::params::group,
    require => Anchor['ironic::install::end'],
    tag     => 'ironic-tftp-file',
  }

  if $tftp_use_xinetd {
    if ! $ironic::params::xinetd_available {
      fail('xinetd is not available in this distro. Please use tftp_use_xinetd=false')
    }

    package { 'tftp-server':
      ensure => $package_ensure,
      name   => $ironic::params::tftpd_package,
      tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
    }

    $tftp_options = "--map-file ${tftp_root_real}/map-file"

    include xinetd

    xinetd::service { 'tftp':
      port        => '69',
      bind        => $tftp_bind_host,
      protocol    => 'udp',
      server_args => "${tftp_options} ${tftp_root_real}",
      server      => '/usr/sbin/in.tftpd',
      socket_type => 'dgram',
      cps         => '100 2',
      per_source  => '11',
      wait        => 'yes',
      subscribe   => Anchor['ironic::install::end'],
    }

    file { "${tftp_root_real}/map-file":
      ensure  => 'file',
      content => "r ^([^/]) ${tftp_root_real}/\\1",
    }
  } else {
    if ! $ironic::params::dnsmasq_tftp_package {
      fail('ironic-dnsmasq-tftp-server is not available in this distro. Please use tftp_use_xnetd=true')
    }

    # NOTE(tkajinam): We can't use puppet-xinetd for cleanup because the xinetd
    #                 class forcefully installs the xinetd package.
    warning('Any prior xinetd based tftp server should be disabled and removed from the system.')

    file { "${tftp_root_real}/map-file":
      ensure => 'absent',
    }

    package { 'dnsmasq-tftp-server':
      ensure => $package_ensure,
      name   => $ironic::params::dnsmasq_tftp_package,
      tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
    }

    file { '/etc/ironic/dnsmasq-tftp-server.conf':
      ensure  => 'file',
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('ironic/dnsmasq_tftp_server.erb'),
      require => Anchor['ironic::config::begin'],
      before  => Anchor['ironic::config::end'],
    }

    if $manage_service {
      if $enabled {
        $ensure = 'running'
      } else {
        $ensure = 'stopped'
      }

      service { 'dnsmasq-tftp-server':
        ensure    => $ensure,
        name      => $ironic::params::dnsmasq_tftp_service,
        enable    => $enabled,
        hasstatus => true,
        subscribe => File['/etc/ironic/dnsmasq-tftp-server.conf'],
      }

      Package['dnsmasq-tftp-server'] ~> Service['dnsmasq-tftp-server']
      File[$tftp_root_real] -> Service['dnsmasq-tftp-server']
    }
  }

  # NOTE(tkajinam): Ubuntu/Debian requires a separate package for pxelinux.0
  #                 and the file is stored in a different path.
  if $pxelinux_path {
    if $ironic::params::pxelinux_package {
      package { 'pxelinux':
        ensure => $package_ensure,
        name   => $ironic::params::pxelinux_package,
        tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
      }
    }

    ironic::pxe::tftpboot_file { 'pxelinux.0':
      source_directory      => $pxelinux_path,
      destination_directory => $tftp_root_real,
      require               => Anchor['ironic::install::end'],
    }
  }

  if $syslinux_path {
    package { 'syslinux':
      ensure => $package_ensure,
      name   => $ironic::params::syslinux_package,
      tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
    }

    ironic::pxe::tftpboot_file { $syslinux_files:
      source_directory      => $syslinux_path,
      destination_directory => $tftp_root_real,
      require               => Anchor['ironic::install::end'],
    }
  }

  package { 'ipxe':
    ensure => $package_ensure,
    name   => $ironic::params::ipxe_package,
    tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
  }

  file { "${tftp_root_real}/undionly.kpxe":
    ensure    => 'file',
    seltype   => 'tftpdir_t',
    owner     => $ironic::params::user,
    group     => $ironic::params::group,
    mode      => '0744',
    source    => "${ironic::params::ipxe_rom_dir}/undionly.kpxe",
    backup    => false,
    show_diff => false,
    require   => Anchor['ironic::install::end'],
    tag       => 'ironic-tftp-file',
  }

  file { "${tftp_root_real}/${uefi_ipxe_bootfile_name_real}":
    ensure    => 'file',
    seltype   => 'tftpdir_t',
    owner     => $ironic::params::user,
    group     => $ironic::params::group,
    mode      => '0744',
    source    => "${ironic::params::ipxe_rom_dir}/${ipxe_name_base}${arch}.efi",
    backup    => false,
    show_diff => false,
    require   => Anchor['ironic::install::end'],
    tag       => 'ironic-tftp-file',
  }

  ensure_resource( 'package', 'grub-efi', {
    ensure => $package_ensure,
    name   => $ironic::params::grub_efi_package,
    tag    => ['openstack', 'ironic-support-package'],
  })

  file { "${tftp_root_real}/grubx64.efi":
    ensure    => 'file',
    seltype   => 'tftpdir_t',
    owner     => $ironic::params::user,
    group     => $ironic::params::group,
    mode      => '0744',
    source    => $ironic::params::grub_efi_file,
    backup    => false,
    show_diff => false,
    require   => Anchor['ironic::install::end'],
    tag       => 'ironic-tftp-file',
  }

  ensure_resource( 'package', 'shim', {
    ensure => $package_ensure,
    name   => $ironic::params::shim_package,
    tag    => ['openstack', 'ironic-support-package'],
  })

  file { "${tftp_root_real}/${uefi_pxe_bootfile_name_real}":
    ensure    => 'file',
    seltype   => 'tftpdir_t',
    owner     => $ironic::params::user,
    group     => $ironic::params::group,
    mode      => '0744',
    source    => $ironic::params::shim_file,
    backup    => false,
    show_diff => false,
    require   => Anchor['ironic::install::end'],
    tag       => 'ironic-tftp-file',
  }

  File[$tftp_root_real] -> File<| tag == 'ironic-tftp-file' |>

  # HTTP server
  if $manage_http_server {
    file { $http_root_real:
      ensure  => 'directory',
      seltype => 'httpd_sys_content_t',
      owner   => $ironic::params::user,
      group   => $ironic::params::group,
      require => Anchor['ironic::config::begin'],
      before  => Anchor['ironic::config::end'],
    }

    include apache

    create_resources(apache::vhost, {
      'ipxe_vhost' => {
        'priority' => $vhost_priority,
        'options'  => $vhost_options,
        'docroot'  => $http_root_real,
        'port'     => $http_port_real,
      }
    }, $vhost_config)
  }
}
