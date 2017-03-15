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

# Internal define for hardware interfaces declaration
#
# === Parameters
#
# [*interface_type*]
#   Interface type name (e.g. 'boot').
#   Defaults to namevar.
#
# [*enabled_list*]
#   List of enabled implementations.
#   Defaults to $::os_service_default
#
# [*default*]
#   The default implementation to use when none is requested by a user.
#   Defaults to $::os_service_default
#
define ironic::drivers::hardware_interface (
  $interface_type = $title,
  $enabled_list   = $::os_service_default,
  $default        = $::os_service_default,
) {

  include ::ironic::deps

  if !is_service_default($enabled_list) and !empty($enabled_list){
    validate_array($enabled_list)
    $enabled_list_real = join($enabled_list, ',')
  } else {
    $enabled_list_real = $::os_service_default
  }

  ironic_config {
    "DEFAULT/enabled_${interface_type}_interfaces": value => $enabled_list_real;
    "DEFAULT/default_${interface_type}_interface":  value => $default;
  }
}

