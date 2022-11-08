# Class ironic::drivers::staging
#
# Manages the ironic-staging-drivers package on systems
#
# === Parameters:
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to present
#
class ironic::drivers::staging (
  $package_ensure = present
) {

  include ironic::deps
  include ironic::params

  if $::ironic::params::staging_drivers_package {
    package { 'ironic-staging-drivers':
      ensure => $package_ensure,
      name   => $::ironic::params::staging_drivers_package,
      tag    => ['openstack', 'ironic-support-package'],
    }
  } else {
    fail('This distribution does not provide the staging driver package.')
  }
}
