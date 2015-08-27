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
#
# Unit tests for ironic::bifrost class
#

require 'spec_helper'

describe 'ironic::bifrost' do

  let :default_params do
    { :git_source_repo => 'https://git.openstack.org/openstack/bifrost',
      :revision => master,
      :git_dest_repo_folder => '/opt/stack/bifrost',
      :bifrost_config_folder => '/etc/bifrost',
      :ironic_url => '"http://localhost:6385/"',
      :network_interface => '"virbr0"',
      :testing => false,
      :testing_user => 'ubuntu',
      :http_boot_folder => '/httpboot',
      :nginx_port => 8080,
      :ssh_public_key_path => '"{{ ansible_env.HOME }}/.ssh/id_rsa.pub"',
      :deploy_kernel => '"{{http_boot_folder}}/coreos_production_pxe.vmlinuz"',
      :deploy_ramdisk => '"{{http_boot_folder}}/coreos_production_pxe_image-oem.cpio.gz"',
      :deploy_kernel_url => '"http://{{ hostvars[inventory_hostname][\'ansible_\' + network_interface][\'ipv4\'][\'address\'] }}:{{nginx_port}}/coreos_production_pxe.vmlinuz"',
      :deploy_ramdisk_url => '"http://{{ hostvars[inventory_hostname][\'ansible_\' + network_interface][\'ipv4\'][\'address\'] }}:{{nginx_port}}/coreos_production_pxe_image-oem.cpio.gz"',
      :deploy_image_filename => '"deployment_image.qcow2"',
      :deploy_image => '"{{http_boot_folder}}/{{deploy_image_filename}}"',
      :create_image_via_dib => true,
      :transform_boot_image => false,
      :node_default_network_interface => 'eth0',
      :ipv4_subnet_mask => '255.255.255.0',
      :ipv4_gateway => '192.168.1.1',
      :ipv4_nameserver => '8.8.8.8',
      :network_mtu => '1500',
      :dhcp_pool_start => '192.168.1.200',
      :dhcp_pool_end => '192.168.1.250',
      :ipmi_bridging => 'no',
    }
  end

  let :params do
    { :mysql_password => 'changeme',
      :ironic_db_password => 'changeme',
      :baremetal_json_hosts => 'test',
    }
  end

  it 'should clone with vcsrepo bifrost repo with master branch' do
    should contain_vcsrepo('/opt/stack/bifrost').with(
      'ensure'   => 'present',
      'provider' => 'git',
      'revision' => 'master',
      'source'   => 'https://git.openstack.org/openstack/bifrost',
    )
  end

  it 'should contain folder /etc/bifrost' do
    should contain_file('/etc/bifrost').with(
      'ensure'  => 'directory',
    )
  end

  it 'should contain file /etc/bifrost/bifrost_global_vars' do
    should contain_file('/etc/bifrost/bifrost_global_vars').with(
      'ensure'  => 'present',
      'require' => 'File[/etc/bifrost]',
      'content' => /ironic_url/,
    )
  end

  it 'should contain file /etc/bifrost/baremetal.json' do
    should contain_file('/etc/bifrost/baremetal.json').with(
      'ensure'  => 'present',
      'require' => 'File[/etc/bifrost]',
      'content' => /test/,
    )
  end

end
