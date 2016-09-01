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

# Configure the deploy_utils in Ironic
# This manifest is deprecated, use ironic::conductor directly instead.
#
# === Parameters
#
# [*http_url*]
#   (optional) ironic-conductor node's HTTP server URL. DEPRECATED.
#   Defaults to undef
#
# [*http_root*]
#   (optional) ironic-conductor node's HTTP root path. DEPRECATED.
#   Defaults to undef
#

class ironic::drivers::deploy (
  $http_url  = undef,
  $http_root = undef,
) {

  if $http_url {
    warning('http_url is deprecated and will be removed after Newton cycle.')
  }

  if $http_root {
    warning('http_root is deprecated and will be removed after Newton cycle.')
  }

}
