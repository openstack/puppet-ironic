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
# ironic::db::mysql
#
# [*password*]
#   (Required) Password to use for the ironic user
#
# [*dbname*]
#   (Optional) The name of the database
#   Defaults to 'ironic'
#
# [*user*]
#   (Optional) The mysql user to create
#   Defaults to 'ironic'
#
# [*host*]
#   (Optional) The IP address of the mysql server
#   Defaults to '127.0.0.1'
#
# [*charset*]
#   (Optional) The charset to use for the ironic database
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) The collate to use for the ironic database
#   Defaults to 'utf8_general_ci'
#
# [*allowed_hosts*]
#   (Optional) Additional hosts that are allowed to access this DB
#   Defaults to undef
#
class ironic::db::mysql (
  $password,
  $dbname        = 'ironic',
  $user          = 'ironic',
  $host          = '127.0.0.1',
  $allowed_hosts = undef,
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
) {

  include ::ironic::deps

  ::openstacklib::db::mysql { 'ironic':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['ironic::db::begin']
  ~> Class['ironic::db::mysql']
  ~> Anchor['ironic::db::end']
}
