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

# Configure parameters related to the "dnsmasq" PXE filter
#
# === Parameters
#
# [*dnsmasq_start_command*]
#   (optional) A (shell) command line to start the dnsmasq service.
#   Defaults to $::os_service_default.
#
# [*dnsmasq_stop_command*]
#   (optional) A (shell) command line to stop the dnsmasq service.
#   Defaults to $::os_service_default.
#
class ironic::inspector::pxe_filter::dnsmasq (
  $dnsmasq_start_command = $::os_service_default,
  $dnsmasq_stop_command  = $::os_service_default,
) {

  include ::ironic::deps
  include ::ironic::inspector

  $hostsdir = pick($::ironic::inspector::dnsmasq_dhcp_hostsdir, $::os_service_default)

  ironic_inspector_config {
    'dnsmasq_pxe_filter/dhcp_hostsdir':         value => $hostsdir;
    'dnsmasq_pxe_filter/dnsmasq_start_command': value => $dnsmasq_start_command;
    'dnsmasq_pxe_filter/dnsmasq_stop_command':  value => $dnsmasq_stop_command;
  }

}
