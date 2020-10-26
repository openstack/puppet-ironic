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

# Configure the IPMI driver in Ironic
#
# === Parameters
#
# [*command_retry_timeout*]
#   (optional) Maximum time in seconds to retry IPMI operations.
#   Should be an interger value
#   Defaults to $::os_service_default
#
# [*min_command_interval*]
#   (optional) Minimum time, in seconds, between IPMI operations.
#   Should be an interger value
#   Defaults to $::os_service_default
#
# [*use_ipmitool_retries*]
#   (optional) Whether the retry feature in ipmitool is used.
#   Defaults to $::os_service_default
#
# [*kill_on_timeout*]
#   (optional) Kill ipmitool process when the timeout expires.
#   Defaults to $::os_service_default
#
# [*disable_boot_timeout*]
#   (optional) Whether ironic sends a raw IPMI command to dsiable the 60 second
#   timeout for booting.
#   Defaults to $::os_service_default
#
# [*debug*]
#   (optional) Enables debug outputs of IPMI commands
#   Defaults to $::os_service_default
#
class ironic::drivers::ipmi (
  $command_retry_timeout = $::os_service_default,
  $min_command_interval  = $::os_service_default,
  $use_ipmitool_retries  = $::os_service_default,
  $kill_on_timeout       = $::os_service_default,
  $disable_boot_timeout  = $::os_service_default,
  $debug                 = $::os_service_default,
) {

  include ironic::deps

  # Configure ironic.conf
  ironic_config {
    'ipmi/command_retry_timeout': value => $command_retry_timeout;
    'ipmi/min_command_interval':  value => $min_command_interval;
    'ipmi/use_ipmitool_retries':  value => $use_ipmitool_retries;
    'ipmi/kill_on_timeout':       value => $kill_on_timeout;
    'ipmi/disable_boot_timeout':  value => $disable_boot_timeout;
    'ipmi/debug':                 value => $debug;
  }

}
