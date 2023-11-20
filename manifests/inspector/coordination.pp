# == Class: ironic::inspector::coordination
#
# Setup and configure ironic-inspector coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $facts['os_service_default']
#
class ironic::inspector::coordination (
  $backend_url = $facts['os_service_default'],
) {

  include ironic::deps

  oslo::coordination{ 'ironic_inspector_config':
    backend_url => $backend_url,
    tag         => 'ironic-inspector',
  }
}
