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

# Configure the interfaces in Ironic
#
# === Parameters
#
# [*enabled_network_interfaces*]
#   (optional) Specify the list of network drivers to load during
#   service initialization.
#   Defaults to $::os_service_default
#

class ironic::drivers::interfaces (
  $enabled_network_interfaces = $::os_service_default,
) {

  if !is_service_default($enabled_network_interfaces) and !empty($enabled_network_interfaces){
    validate_array($enabled_network_interfaces)
    $enabled_network_interfaces_real = join($enabled_network_interfaces, ',')
  } else {
    $enabled_network_interfaces_real = $::os_service_default
  }

  ironic_config {
    'DEFAULT/enabled_network_interfaces': value => $enabled_network_interfaces_real;
  }

}
