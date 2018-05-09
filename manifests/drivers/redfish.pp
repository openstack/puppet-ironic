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

# Configure the Redfish driver in Ironic
#
# === Parameters
#
# [*package_ensure*]
#   (optional) The state of the sushy package
#   Defaults to 'present'
#
# [*connection_attempts*]
#   (optional) Maximum number of attempts to try to connect to Redfish.
#   Should be a positive integer value.
#   Defaults to $::os_service_default.
#
# [*connection_retry_interval*]
#   (optional) Number of seconds to wait between attempts to connect to Redfish
#   Should be a positive integer value.
#   Defaults to $::os_service_default.
#
class ironic::drivers::redfish (
  $package_ensure            = 'present',
  $connection_attempts       = $::os_service_default,
  $connection_retry_interval = $::os_service_default,
) {

  include ::ironic::deps
  include ::ironic::params

  ironic_config {
    'redfish/connection_attempts':       value => $connection_attempts;
    'redfish/connection_retry_interval': value => $connection_retry_interval;
  }

  ensure_packages('python-sushy',
    {
      ensure => $package_ensure,
      name   => $::ironic::params::sushy_package_name,
      tag    => ['openstack', 'ironic-package'],
    }
  )

}
