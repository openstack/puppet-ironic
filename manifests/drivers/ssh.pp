# Copyright 2016 Red Hat, Inc.
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Configure the SSH driver in Ironic
#
# === Parameters
#
# [*libvirt_uri*]
#   (optional) libvirt URI.
#   Defaults to $::os_service_default.
#
class ironic::drivers::ssh (
  $libvirt_uri = $::os_service_default,
) {

  include ::ironic::deps

  warning("The *_ssh family of drivers was deprecated in Ironic in the Newton \
release, and will be removed in Pike. The ironic::drivers::ssh module will \
become noop then, and will be removed in Queens. Please switch to using \
*_ipmitool family of drivers with virtualbmc for virtual testing.")

  # Configure ironic.conf
  ironic_config {
    'ssh/libvirt_uri': value => $libvirt_uri;
  }

}
