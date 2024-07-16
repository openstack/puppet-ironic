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
# Configure the IPA-related parameters in Ironic
#
# === Parameters
#
# [*manage_agent_boot*]
#   (optional) Whether Ironic will managed booting of the agent ramdisk.
#   Defaults to $facts['os_service_default']
#
# [*memory_consumed_by_agent*]
#   (optional) The memory size in MIB consumed by agent when it is booted on
#   a bare metal node.
#   Defaults to $facts['os_service_default']
#
# [*stream_raw_images*]
#   (optional) Whether to stream raw images directly on the hard drive instead
#   of first caching them in memory. Ignored when iSCSI is used for deploy.
#   Defaults to $facts['os_service_default']
#
# [*image_download_source*]
#   (optional) Specifies whether direct deploy interface should try to use
#   the image source directly or if ironic should cache the image on
#   the conductor and serve it from ironic's own http server.
#   Accepts values "swift" (the default) or "http".
#   Defaults to $facts['os_service_default']
#
# [*post_deploy_get_power_state_retries*]
#   (optional) Number of retries getting power state after a soft power off.
#   Must be a valid integer.
#   Defaults to $facts['os_service_default']
#
# [*post_deploy_get_power_state_retry_interval*]
#   (optional) Amount of time (in seconds) to wait between polling power state
#   after the soft power off.
#   Defaults to $facts['os_service_default']
#
# [*deploy_logs_collect*]
#   (optional) Whether and when to collect IPA logs after deployment.
#   Accepts values "always", "on_failure", "never".
#   Defaults to $facts['os_service_default']
#
# [*deploy_logs_storage_backend*]
#   (optional) The backend to store IPA logs, if enabled.
#   Accepts values "local" and "swift".
#   Defaults to $facts['os_service_default']
#
# [*deploy_logs_local_path*]
#   (optional) The path to store IPA logs if deploy_logs_storage_backend is
#   "local" (ignored otherwise).
#   Defaults to $facts['os_service_default']
#
# [*deploy_logs_swift_container*]
#   (optional) Swift container to store IPA logs if deploy_logs_storage_backend
#   is "swift" (ignored otherwise).
#   Defaults to $facts['os_service_default']
#
# [*deploy_logs_swift_days_to_expire*]
#   (optional) Number of days before IPA logs expire in Swift.
#   Defaults to $facts['os_service_default']
#
# [*command_timeout*]
#   (optional) Timeout in seconds to wait for a response from the agent.
#   Defaults to $facts['os_service_default']
#
# [*max_command_attempts*]
#   (optional) Number of times to try connecting to the agent for a command.
#   Defaults to $facts['os_service_default']
#
# [*command_wait_attempts*]
#   (optional) Number of attempts to check for asynchronous commands completion
#   before timing out.
#   Defaults to $facts['os_service_default']
#
# [*command_wait_interval*]
#   (optional) Number of seconds to wait for between checks for asynchronous
#   commands completion.
#   Defaults to $facts['os_service_default']
#
# [*neutron_agent_poll_interval*]
#   (optional) The number of seconds Neutron agent will wait between polling
#   for device changes.
#   Defaults to $facts['os_service_default']
#
# [*neutron_agent_max_attempts*]
#   (optional) Max number of attempts to validate a Neutron agent status before
#   raising network error for a dead agent.
#   Defaults to $facts['os_service_default']
#
# [*neutron_agent_status_retry_interval*]
#   (optional) Wait time in seconds between attempts for validating Neutron
#   agent status.
#   Defaults to $facts['os_service_default']
#
# [*require_tls*]
#   (optional) If set to False, callback URLs without https:// will be
#   permitted by the conductor.
#   Defaults to $facts['os_service_default']
#
# [*certificates_path*]
#   (optional) Path to store auto-generated TLS certificates used to validate
#   connections to the ramdisk.
#   Defaults to $facts['os_service_default']
#
# [*verify_ca*]
#   (optional) Path to the TLS CA to validate connection to the ramdisk.
#   Defaults to $facts['os_service_default']
#
# [*api_ca_file*]
#   (optional) Path to the TLS CA that is used to start the bare metal API.
#   Defaults to $facts['os_service_default']
#
# [*allow_md5_checksum*]
#   (optional) When enabled, the agent will be notified it is permitted to
#   consider MD5 checksums.
#   Defaults to $facts['os_service_default']
#
class ironic::drivers::agent (
  $manage_agent_boot                            = $facts['os_service_default'],
  $memory_consumed_by_agent                     = $facts['os_service_default'],
  $stream_raw_images                            = $facts['os_service_default'],
  $image_download_source                        = $facts['os_service_default'],
  $post_deploy_get_power_state_retries          = $facts['os_service_default'],
  $post_deploy_get_power_state_retry_interval   = $facts['os_service_default'],
  $deploy_logs_collect                          = $facts['os_service_default'],
  $deploy_logs_storage_backend                  = $facts['os_service_default'],
  $deploy_logs_local_path                       = $facts['os_service_default'],
  $deploy_logs_swift_container                  = $facts['os_service_default'],
  $deploy_logs_swift_days_to_expire             = $facts['os_service_default'],
  $command_timeout                              = $facts['os_service_default'],
  $max_command_attempts                         = $facts['os_service_default'],
  $command_wait_attempts                        = $facts['os_service_default'],
  $command_wait_interval                        = $facts['os_service_default'],
  $neutron_agent_poll_interval                  = $facts['os_service_default'],
  $neutron_agent_max_attempts                   = $facts['os_service_default'],
  $neutron_agent_status_retry_interval          = $facts['os_service_default'],
  $require_tls                                  = $facts['os_service_default'],
  $certificates_path                            = $facts['os_service_default'],
  $verify_ca                                    = $facts['os_service_default'],
  $api_ca_file                                  = $facts['os_service_default'],
  $allow_md5_checksum                           = $facts['os_service_default'],
) {

  include ironic::deps

  # Configure ironic.conf
  ironic_config {
    'agent/manage_agent_boot':                          value => $manage_agent_boot;
    'agent/memory_consumed_by_agent':                   value => $memory_consumed_by_agent;
    'agent/stream_raw_images':                          value => $stream_raw_images;
    'agent/image_download_source':                      value => $image_download_source;
    'agent/post_deploy_get_power_state_retries':        value => $post_deploy_get_power_state_retries;
    'agent/post_deploy_get_power_state_retry_interval': value => $post_deploy_get_power_state_retry_interval;
    'agent/deploy_logs_collect':                        value => $deploy_logs_collect;
    'agent/deploy_logs_storage_backend':                value => $deploy_logs_storage_backend;
    'agent/deploy_logs_local_path':                     value => $deploy_logs_local_path;
    'agent/deploy_logs_swift_container':                value => $deploy_logs_swift_container;
    'agent/deploy_logs_swift_days_to_expire':           value => $deploy_logs_swift_days_to_expire;
    'agent/command_timeout':                            value => $command_timeout;
    'agent/max_command_attempts':                       value => $max_command_attempts;
    'agent/command_wait_attempts':                      value => $command_wait_attempts;
    'agent/command_wait_interval':                      value => $command_wait_interval;
    'agent/neutron_agent_poll_interval':                value => $neutron_agent_poll_interval;
    'agent/neutron_agent_max_attempts':                 value => $neutron_agent_max_attempts;
    'agent/neutron_agent_status_retry_interval':        value => $neutron_agent_status_retry_interval;
    'agent/require_tls':                                value => $require_tls;
    'agent/certificates_path':                          value => $certificates_path;
    'agent/verify_ca':                                  value => $verify_ca;
    'agent/api_ca_file':                                value => $api_ca_file;
    'agent/allow_md5_checksum':                         value => $allow_md5_checksum;
  }
}
