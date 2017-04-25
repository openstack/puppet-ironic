# Class ironic::inspector::client
#
# Manages the ironic inspector client package on systems
#
# === Parameters:
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to present
#
class ironic::inspector::client (
  $package_ensure = present
) {

  include ::ironic::deps
  include ::ironic::params

  package { 'python-ironic-inspector-client':
    ensure => $package_ensure,
    name   => $::ironic::params::inspector_client_package,
    tag    => ['openstack', 'ironic-support-package'],
  }

}
