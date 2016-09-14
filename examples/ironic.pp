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
# Deploy Ironic
#

$db_host     = 'db'
$db_username = 'ironic'
$db_name     = 'ironic'
$db_password = 'password'
$rabbit_user     = 'ironic'
$rabbit_password = 'ironic'
$rabbit_vhost    = '/'
$rabbit_hosts    = ['rabbitmq:5672']
$rabbit_port     = '5672'
$glance_api_servers = 'glance:9292'
$deploy_kernel  = 'glance://deploy_kernel_uuid'
$deploy_ramdisk = 'glance://deploy_ramdisk_uuid'
$baremetal_json_hosts = '
  "ironic-bm-test.bifrost.example": {
    "ansible_ssh_host": "1.1.1.1",
    "uuid": "11111111-1111-1111-1111-111111111111",
    "driver_info": {
      "power": {
        "ipmi_address": "10.0.0.1",
        "ipmi_username": "admin",
        "ipmi_password": "pass"
      },
    },
    "nics": [
      {
        "mac": "ff:ff:ff:ff:ff:ff"
      }
    ],
    "driver": "agent_ipmitool",
    "ipv4_address": "1.1.1.1",
    "properties": {
      "cpu_arch": "x86_64",
      "ram": null,
       "disk_size": null,
       "cpus": null
    },
    "name": "ironic-bm-test.bifrost.example"
  }
'

node 'db' {

  class { '::mysql::server':
    config_hash => {
      'bind_address' => '0.0.0.0',
    },
  }

  class { '::mysql::ruby': }

  class { '::ironic::db::mysql':
    password      => $db_password,
    dbname        => $db_name,
    user          => $db_username,
    host          => $clientcert,
    allowed_hosts => ['controller'],
  }

}

node 'controller' {

  class { '::ironic':
    db_password         => $db_password,
    db_name             => $db_name,
    db_user             => $db_username,
    db_host             => $db_host,

    rabbit_password     => $rabbit_password,
    rabbit_userid       => $rabbit_user,
    rabbit_virtual_host => $rabbit_vhost,
    rabbit_hosts        => $rabbit_hosts,

    glance_api_servers  => $glance_api_servers,
  }

  class { '::ironic::api': }

  class { '::ironic::conductor': }

  class { '::ironic::drivers::ipmi': }

  class { '::ironic::drivers::pxe':
    deploy_kernel  => $deploy_kernel,
    deploy_ramdisk => $deploy_ramdisk,
  }

}

node 'bifrost-controller' {

  class { '::ironic::bifrost':
    network_interface    => 'eth1',
    ironic_db_password   => 'changeme',
    mysql_password       => 'changemetoo',
    baremetal_json_hosts => $baremetal_json_hosts,
  }

}
