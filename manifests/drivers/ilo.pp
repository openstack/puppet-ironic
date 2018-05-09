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

# Configure the iLO driver in Ironic
#
# === Parameters
#
# [*client_timeout*]
#   (optional) Maximum time in seconds to wait for iLO commands.
#   Should be an interger value
#   Defaults to $::os_service_default.
#
# [*client_port*]
#   (optional) Port to use for iLO operations.
#   Defaults to $::os_service_default.
#
# [*use_web_server_for_images*]
#   (optional) Whether to use the Web server (the same as used for iPXE)
#   to host virtual media images.
#   Defaults to $::os_service_default.
#
# [*default_boot_mode*]
#   (optional) The default boot mode to use when no boot mode is explicitly
#   requested. Accepts values "uefi", "bios" and "auto". The "auto" value will
#   use UEFI if it's available on the machine, BIOS otherwise.
#   Defaults to $::os_service_default.
#
# [*package_ensure*]
#   (optional) The state of the proliantutils package
#   Defaults to 'present'
#
class ironic::drivers::ilo (
  $client_timeout            = $::os_service_default,
  $client_port               = $::os_service_default,
  $use_web_server_for_images = $::os_service_default,
  $default_boot_mode         = $::os_service_default,
  $package_ensure            = 'present',
) {

  include ::ironic::deps
  include ::ironic::params

  # Configure ironic.conf
  ironic_config {
    'ilo/client_timeout':            value => $client_timeout;
    'ilo/client_port':               value => $client_port;
    'ilo/use_web_server_for_images': value => $use_web_server_for_images;
    'ilo/default_boot_mode':         value => $default_boot_mode;
  }

  ensure_packages('python-proliantutils',
    {
      ensure => $package_ensure,
      name   => $::ironic::params::proliantutils_package_name,
      tag    => ['openstack', 'ironic-package'],
    }
  )

}
