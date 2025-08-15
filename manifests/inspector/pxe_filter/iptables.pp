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

# Configure parameters related to the "iptables" PXE filter
#
# === Parameters
#
# [*firewall_chain*]
#   (optional) iptables chain name to use.
#   Defaults to $facts['os_service_default'].
#
# [*ethoib_interfaces*]
#   (optional) List of Ethernet Over InfiniBand interfaces on the Inspector
#   host which are used for physical access to the DHCP network.
#   Defaults to $facts['os_service_default'].
#
# [*ip_version*]
#   (optional) The IP version that will be used for iptables filter.
#   Defaults to $facts['os_service_default'].
#
class ironic::inspector::pxe_filter::iptables (
  $firewall_chain    = $facts['os_service_default'],
  $ethoib_interfaces = $facts['os_service_default'],
  $ip_version        = $facts['os_service_default'],
) {

  include ironic::deps
  include ironic::inspector

  ironic_inspector_config {
    'iptables/dnsmasq_interface': value => $ironic::inspector::dnsmasq_interface;
    'iptables/firewall_chain':    value => $firewall_chain;
    'iptables/ethoib_interfaces': value => join(any2array($ethoib_interfaces), ',');
    'iptables/ip_version':        value => $ip_version;
  }
}
