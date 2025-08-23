# == Class: ironic::inventory
#
# Configure the inventory parameters
#
# === Parameters
#
# [*data_backend*]
#  (Optional) The storage backend for storing introspection data.
#  Defaults to $facts['os_service_default'].
#
# [*swift_data_container*]
#  (Optional) The Swift introspection data container to store the inventory
#  data.
#  Defaults to $facts['os_service_default'].
#
class ironic::inventory (
  $data_backend         = $facts['os_service_default'],
  $swift_data_container = $facts['os_service_default'],
) {
  include ironic::deps
  include ironic::params

  if ! is_service_default($data_backend) {
    if ! member(['none', 'database', 'swift'], $data_backend) {
      fail('Unsupported data backend')
    }
  }

  ironic_config {
    'inventory/data_backend':         value => $data_backend;
    'inventory/swift_data_container': value => $swift_data_container;
  }
}
