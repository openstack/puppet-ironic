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
#
# Configure the DRAC driver in Ironic
#
# === Parameters
#
# [*package_ensure*]
#   (optional) The state of the sushy-oem-idrac package
#   Defaults to 'present'
#
# [*query_raid_config_job_status_interval*]
#   (optional) Interval (in seconds) between periodic RAID job status checks.
#   Defaults to $facts['os_service_default']
#
# [*boot_device_job_status_timeout*]
#   (optional) Maximum amount of time (in seconds) to wait for the boot device
#   configuration.
#   Defaults to $facts['os_service_default']
#
# [*query_import_config_job_status_interval*]
#   (optional) Number of seconds to wait between checking for completed
#   import configuration task.
#   Defaults to $facts['os_service_default']
#
# [*raid_job_timeout*]
#   (optional) Maximum time (in seconds) to wait for RAID job to complete.
#   Defaults to $facts['os_service_default']
#
# DEPRECATED PARAMETERS
#
# [*config_job_max_retries*]
#   (optional) Maximum number of retries for the configuration job to
#   complete successfully
#   Defaults to undef
#
# [*bios_factory_reset_timeout*]
#   (optional) Maximum time (in seconds) to wait for factory reset of BIOS
#   settings to complete.
#   Defaults to undef
#
class ironic::drivers::drac (
  Stdlib::Ensure::Package $package_ensure  = 'present',
  $query_raid_config_job_status_interval   = $facts['os_service_default'],
  $boot_device_job_status_timeout          = $facts['os_service_default'],
  $query_import_config_job_status_interval = $facts['os_service_default'],
  $raid_job_timeout                        = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $config_job_max_retries                  = undef,
  $bios_factory_reset_timeout              = undef,
) {
  include ironic::deps
  include ironic::params

  [
    'config_job_max_retries',
    'bios_factory_reset_timeout',
  ].each |String $deprecated_param| {
    if getvar($deprecated_param) != undef {
      warning("The ${deprecated_param} parameter is deprecated and has no effect.")
    }
  }

  ironic_config {
    'drac/query_raid_config_job_status_interval':   value => $query_raid_config_job_status_interval;
    'drac/boot_device_job_status_timeout':          value => $boot_device_job_status_timeout;
    'drac/query_import_config_job_status_interval': value => $query_import_config_job_status_interval;
    'drac/raid_job_timeout':                        value => $raid_job_timeout;
  }

  # TODO(tkajinam): Remove this after 2026.1
  ironic_config {
    'drac/config_job_max_retries':     ensure => absent;
    'drac/bios_factory_reset_timeout': ensure => absent;
  }

  package { 'python-sushy-oem-idrac':
    ensure => $package_ensure,
    name   => $ironic::params::sushy_oem_idrac_package_name,
    tag    => ['openstack', 'ironic-package'],
  }
}
