#
# Copyright (C) 2016 Red Hat, Inc.
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


# Common setup for Ironic PXE boot
#
#   This class allows to globally override configuration for PXE
#   configuration of Ironic.
#
# === Parameters
#
# [*http_port*]
#   (optional) port used by the HTTP service serving introspection images.
#   Defaults to undef.
#
# [*tftp_root*]
#   (optional) Folder location to deploy PXE boot files
#   Defaults to undef.
#
# [*http_root*]
#   (optional) Folder location to deploy HTTP PXE boot
#   Defaults to undef.
#
# [*ipxe_timeout*]
#   (optional) ipxe timeout in second. Should be an integer.
#   Defaults to undef.
#
class ironic::pxe::common (
  $tftp_root        = undef,
  $http_root        = undef,
  $http_port        = undef,
  $ipxe_timeout     = undef,
) {
  include ::ironic::deps
}
