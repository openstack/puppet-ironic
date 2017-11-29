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

# Configure PXE filters for ironic-inspector
#
# === Parameters
#
# [*driver*]
#   (optional) PXE filter driver to use.
#   Defaults to $::os_service_default.
#
# [*sync_period*]
#   (optional) Number of seconds between periodic updates of filters.
#   Should be a non-negative integer value.
#   Defaults to $::os_service_default.
#
class ironic::inspector::pxe_filter (
  $driver      = $::os_service_default,
  $sync_period = $::os_service_default,
) {

  include ::ironic::deps

  ironic_inspector_config {
    'pxe_filter/driver':      value => $driver;
    'pxe_filter/sync_period': value => $sync_period;
  }

}
