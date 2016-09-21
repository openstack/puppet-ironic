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

# Internal define for coyping tftpboot files
#
# === Parameters
#
# [*source_directory*]
#   Directory to copy file from.
#
# [*destination_directory*]
#   Directory to copy files to.
#
# [*file*]
#   File to copy.
#   Defaults to namevar.
#
define ironic::pxe::tftpboot_file (
  $source_directory,
  $destination_directory,
  $file = $title,
) {
  include ::ironic::deps

  file {"${destination_directory}/${file}":
    ensure  => 'present',
    seltype => 'tftpdir_t',
    owner   => 'ironic',
    group   => 'ironic',
    mode    => '0744',
    source  => "${source_directory}/${file}",
    backup  => false,
  }
}

