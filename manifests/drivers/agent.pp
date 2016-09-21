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

# Configure the IPA-related parameters in Ironic
#
# === Parameters
#
# [*stream_raw_images*]
#   (optional) Whether to stream raw images directly on the hard drive instead
#   of first caching them in memory. Ignored when iSCSI is used for deploy.
#   Defaults to $::os_service_default
#
# [*post_deploy_get_power_state_retries*]
#   (optional) Number of retries getting power state after a soft power off.
#   Must be a valid interger.
#   Defaults to $::os_service_default
#
# [*post_deploy_get_power_state_retry_interval*]
#   (optional) Amount of time (in seconds) to wait between polling power state
#   after the soft power off.
#   Defaults to $::os_service_default
#
# [*deploy_logs_collect*]
#   (optional) Whether and when to collect IPA logs after deployment.
#   Accepts values "always", "on_failure", "never".
#   Defaults to $::os_service_default
#
# [*deploy_logs_storage_backend*]
#   (optional) The backend to store IPA logs, if enabled.
#   Accepts values "local" and "swift".
#   Defaults to $::os_service_default
#
# [*deploy_logs_local_path*]
#   (optional) The path to store IPA logs if deploy_logs_storage_backend is
#   "local" (ignored otherwise).
#   Defaults to $::os_service_default
#
# [*deploy_logs_swift_container*]
#   (optional) Swift container to store IPA logs if deploy_logs_storage_backend
#   is "swift" (ignored otherwise).
#   Defaults to $::os_service_default
#
# [*deploy_logs_swift_days_to_expire*]
#   (optional) Number of days before IPA logs expire in Swift.
#   Defaults to $::os_service_default
#

class ironic::drivers::agent (
  $stream_raw_images                            = $::os_service_default,
  $post_deploy_get_power_state_retries          = $::os_service_default,
  $post_deploy_get_power_state_retry_interval   = $::os_service_default,
  $deploy_logs_collect                          = $::os_service_default,
  $deploy_logs_storage_backend                  = $::os_service_default,
  $deploy_logs_local_path                       = $::os_service_default,
  $deploy_logs_swift_container                  = $::os_service_default,
  $deploy_logs_swift_days_to_expire             = $::os_service_default,
) {

  include ::ironic::deps

  # Configure ironic.conf
  ironic_config {
    'agent/stream_raw_images':                          value => $stream_raw_images;
    'agent/post_deploy_get_power_state_retries':        value => $post_deploy_get_power_state_retries;
    'agent/post_deploy_get_power_state_retry_interval': value => $post_deploy_get_power_state_retry_interval;
    'agent/deploy_logs_collect':                        value => $deploy_logs_collect;
    'agent/deploy_logs_storage_backend':                value => $deploy_logs_storage_backend;
    'agent/deploy_logs_local_path':                     value => $deploy_logs_local_path;
    'agent/deploy_logs_swift_container':                value => $deploy_logs_swift_container;
    'agent/deploy_logs_swift_days_to_expire':           value => $deploy_logs_swift_days_to_expire;
  }

}
