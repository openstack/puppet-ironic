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
#   Defaults to $facts['os_service_default'].
#
# [*connection_retry_interval*]
#   (optional) Number of seconds to wait between attempts to connect to Redfish
#   Should be a positive integer value.
#   Defaults to $facts['os_service_default'].
#
# [*connection_cache_size*]
#   (optional) Maximum Redfish client connection cache size.
#   Defaults to $facts['os_service_default'].
#
# [*auth_type*]
#   (optional) Redfish HTTP client authentication method.
#   Defaults to $facts['os_service_default'].
#
# [*use_swift*]
#   (optional) Upload generated ISO images for virtual media boot to Swift.
#   Defaults to $facts['os_service_default'].
#
# [*swift_container*]
#   (optional) The swift container to store Redfish driver data.
#   Defaults to $facts['os_service_default'].
#
# [*swift_object_expiry_timeout*]
#   (optional) Amount of time in seconds for Swift objects to auto-expire.
#   Defaults to $facts['os_service_default'].
#
# [*kernel_append_params*]
#   (optional) Additional kernel parameters to pass down to the instance kernel
#   Defaults to $facts['os_service_default'].
#
# [*file_permission*]
#   (optional) File permission for swift-less image hosting with the octal
#   permission representation of file access permissions.
#   Defaults to $facts['os_service_default'].
#
# [*firmware_update_status_interval*]
#   (optional) Number of seconds to wait between checking for completed
#   firmware update tasks.
#   Defaults to $facts['os_service_default']
#
# [*firmware_update_fail_interval*]
#   (optional) Number of seconds to wait between checking for failed firmware
#   update tasks.
#   Defaults to $facts['os_service_default']
#
class ironic::drivers::redfish (
  $package_ensure                  = 'present',
  $connection_attempts             = $facts['os_service_default'],
  $connection_retry_interval       = $facts['os_service_default'],
  $connection_cache_size           = $facts['os_service_default'],
  $auth_type                       = $facts['os_service_default'],
  $use_swift                       = $facts['os_service_default'],
  $swift_container                 = $facts['os_service_default'],
  $swift_object_expiry_timeout     = $facts['os_service_default'],
  $kernel_append_params            = $facts['os_service_default'],
  $file_permission                 = $facts['os_service_default'],
  $firmware_update_status_interval = $facts['os_service_default'],
  $firmware_update_fail_interval   = $facts['os_service_default'],
) {

  include ironic::deps
  include ironic::params

  ironic_config {
    'redfish/connection_attempts':             value => $connection_attempts;
    'redfish/connection_retry_interval':       value => $connection_retry_interval;
    'redfish/connection_cache_size':           value => $connection_cache_size;
    'redfish/auth_type':                       value => $auth_type;
    'redfish/use_swift':                       value => $use_swift;
    'redfish/swift_container':                 value => $swift_container;
    'redfish/swift_object_expiry_timeout':     value => $swift_object_expiry_timeout;
    'redfish/kernel_append_params':            value => $kernel_append_params;
    'redfish/file_permission':                 value => $file_permission;
    'redfish/firmware_update_status_interval': value => $firmware_update_status_interval;
    'redfish/firmware_update_fail_interval':   value => $firmware_update_fail_interval;
  }

  ensure_packages('python-sushy',
    {
      ensure => $package_ensure,
      name   => $::ironic::params::sushy_package_name,
      tag    => ['openstack', 'ironic-package'],
    }
  )

}
