# Copyright 2015 Hewlett-Packard Development Company, L.P.
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

# == Class: ironic::bifrost
#
# Installs and configures Bifrost
# Bifrost is a set of Ansible playbooks that automates the task of deploying a
# base image onto a set of known hardware using Ironic. It provides modular
# utility for one-off operating system deployment with as few operational requirements
# as reasonably possible.
# Bifrost also allows to install Ironic in a stand-alone fashion. In this kind of setup,
# neither Keystone nor Neutron is installed, and dnsmasq is used to provide PXE booting.
#
# [*ironic_db_password*]
#   (required) The Ironic DB password
#
# [*mysql_password*]
#   (required) The mysql server password
#
# [*baremetal_json_hosts*]
#   (required) Baremetal hosts in JSON format, will be included in baremetal.json
#
# [*git_source_repo*]
#   (optional) Git repository location for pulling Bifrost
#   Defaults to 'https://git.openstack.org/openstack/bifrost'
#
# [*revision*]
#   (optional) The branch or commit to checkout on Bifrost repository
#   Defaults to 'master'
#
# [*ensure*]
#   (optional) Ensure value for cloning the Bifrost repository.
#   This is a pass-thru variable for vcsrepo, acceptable values are
#   present/bare/absent/latest
#   Typically, you may want to set this value to either present or absent and use
#   revision for setting the branch or commit to clone.
#   Defaults to 'present'
#
# [*revision*]
#   (optional) The branch or commit to checkout on Bifrost repository
#   Defaults to 'master'
#
# [*git_dest_repo_folder*]
#   (optional) Folder to clone the Bifrost git repository
#   Defaults to '/opt/stack/bifrost'
#
# [*ironic_url*]
#   (optional) The URL of the Ironic server
#   Defaults to '"http://localhost:6385"'
#
# [*network_interface*]
#   (optional) The network interface DHCP will serve requests on
#    Defaults to '"virbr0"'
#
# [*testing*]
#   (optional) If true, Ironic will provision libvirt and VMs instead of baremetal
#   Defaults to 'false'
#
# [*testing_user*]
#   (optional) VM default user in case testing is enabled
#   Defaults to 'ubuntu'
#
# [*http_boot_folder*]
#   (optional) gPXE folder location for HTTP PXE boot
#   Defaults to '/httpboot'
#
# [*nginx_port*]
#   (optional) NGINX HTTP port
#   Defaults to 8080

# [*ssh_public_key_path*]
#   (optional) SSH public key location, this will be injected in provisioned servers
#    Defaults to '"{{ ansible_env.HOME }}/.ssh/id_rsa.pub"'
#
# [*deploy_kernel*]
#   (optional) Kernel to PXE boot from
#   Defaults to '"{{http_boot_folder}}/coreos_production_pxe.vmlinuz"'
#
# [*deploy_ramdisk*]
#   (optional) Ramdisk to load after kernel boot
#   Defaults to '"{{http_boot_folder}}/coreos_production_pxe_image-oem.cpio.gz"'
#
# [*deploy_kernel_url*]
#   (optional) Kernel URL
#   Defaults to '"http://{{ hostvars[inventory_hostname][\'ansible_\' + network_interface][\'ipv4\'][\'address\'] }}:{{nginx_port}}/coreos_production_pxe.vmlinuz"'
#
# [*deploy_ramdisk_url*]
#   (optional) Ramdisk URL
#   Defaults to '"http://{{ hostvars[inventory_hostname][\'ansible_\' + network_interface][\'ipv4\'][\'address\'] }}:{{nginx_port}}/coreos_production_pxe_image-oem.cpio.gz"'
#
# [*deploy_image_filename*]
#   (optional) Deploy image filename
#   Defaults to '"deployment_image.qcow2"'
#
# [*deploy_image*]
#   (optional) URL for the deployment image
#   Defaults to '"{{http_boot_folder}}/{{deploy_image_filename}}"'
#
# [*create_image_via_dib*]
#   (optional) Flag to enable/disable image creation with diskimage-builder
#   Defaults to 'true'
#
# [*transform_boot_image*]
#   (optional) Flag to prepend a partition image with boot sector and partition table
#    Defaults to 'false'
#
# [*node_default_network_interface*]
#   (optional) Default network interface to configure with configdrive settings
#   Defaults to 'eth0'
#
# [*ipv4_subnet_mask*]
#   (optional) Subnet mask for configured NIC
#   Defaults to '255.255.255.0'
#
# [*ipv4_gateway*]
#   (optional) Gateway for configured NIC
#   Defaults to '192.168.1.1'
#
# [*ipv4_nameserver*]
#   (optional) Nameserver for DNS configuration
#   Defaults to '8.8.8.8'
#
# [*network_mtu*]
#   (optional) MTU for configured NIC
#   Defaults to '1500'
#
# [*dhcp_pool_start*]
#   (optional) Dnsmasq DHCP pool start
#   Defaults to '192.168.1.200'
#
# [*dhcp_pool_end*]
#   (optional) Dnsmasq DHCP pool end
#   Defaults to '192.168.1.250'
#
# [*ipmi_bridging*]
#   (optional) Flag to enable/disable IPMI bridging
#   Defaults to 'no'

class ironic::bifrost (
  $ironic_db_password,
  $mysql_password,
  $baremetal_json_hosts,
  $git_source_repo                = 'https://git.openstack.org/openstack/bifrost',
  $ensure                         = present,
  $revision                       = 'master',
  $git_dest_repo_folder           = '/opt/stack/bifrost',
  $ironic_url                     = '"http://localhost:6385/"',
  $network_interface              = '"virbr0"',
  $testing                        = false,
  $testing_user                   = 'ubuntu',
  $http_boot_folder               = '/httpboot',
  $nginx_port                     = 8080,
  $ssh_public_key_path            = '"{{ ansible_env.HOME }}/.ssh/id_rsa.pub"',
  $deploy_kernel                  = '"{{http_boot_folder}}/coreos_production_pxe.vmlinuz"',
  $deploy_ramdisk                 = '"{{http_boot_folder}}/coreos_production_pxe_image-oem.cpio.gz"',
  $deploy_kernel_url              = '"http://{{ hostvars[inventory_hostname][\'ansible_\' + network_interface][\'ipv4\'][\'address\'] }}:{{nginx_port}}/coreos_production_pxe.vmlinuz"',
  $deploy_ramdisk_url             = '"http://{{ hostvars[inventory_hostname][\'ansible_\' + network_interface][\'ipv4\'][\'address\'] }}:{{nginx_port}}/coreos_production_pxe_image-oem.cpio.gz"',
  $deploy_image_filename          = '"deployment_image.qcow2"',
  $deploy_image                   = '"{{http_boot_folder}}/{{deploy_image_filename}}"',
  $create_image_via_dib           = true,
  $transform_boot_image           = false,
  $node_default_network_interface = 'eth0',
  $ipv4_subnet_mask               = '255.255.255.0',
  $ipv4_gateway                   = '192.168.1.1',
  $ipv4_nameserver                = '8.8.8.8',
  $network_mtu                    = '1500',
  $dhcp_pool_start                = '192.168.1.200',
  $dhcp_pool_end                  = '192.168.1.250',
  $ipmi_bridging                  = 'no',
) {

  vcsrepo { $git_dest_repo_folder:
    ensure   => $ensure,
    provider => git,
    revision => $revision,
    source   => $git_source_repo,
  }

  file { "${git_dest_repo_folder}/playbooks/inventory/group_vars/all":
    ensure  => present,
    content => template('ironic/group_vars_all.erb'),
    require => Vcsrepo[$git_dest_repo_folder],
  }

  file { "${git_dest_repo_folder}/baremetal.json":
    ensure  => present,
    content => template('ironic/baremetal.json.erb'),
    require => Vcsrepo[$git_dest_repo_folder],
  }
}

