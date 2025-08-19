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

  oslo::coordination { 'ironic_inspector_config':
    backend_url => $backend_url,
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['ironic_inspector_config'] -> Anchor['ironic-inspector::service::begin']
}
