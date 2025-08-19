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
#   Defaults to $facts['os_service_default']
#
# [*default*]
#   The default implementation to use when none is requested by a user.
#   Defaults to $facts['os_service_default']
#
define ironic::drivers::hardware_interface (
  $interface_type = $title,
  $enabled_list   = $facts['os_service_default'],
  $default        = $facts['os_service_default'],
) {
  include ironic::deps

  ironic_config {
    "DEFAULT/enabled_${interface_type}_interfaces": value => join(any2array($enabled_list), ',');
    "DEFAULT/default_${interface_type}_interface":  value => $default;
  }
}
