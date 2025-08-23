# == Class: ironic::reports
#
# Configure oslo_reports options
#
# === Parameters
#
# [*log_dir*]
#   (Optional) Path to a log directory where to create a file
#   Defaults to $facts['os_service_default']
#
# [*file_event_handler*]
#   (Optional) The path to a file to watch for changes to trigger the reports.
#   Defaults to $facts['os_service_default']
#
# [*file_event_handler_interval*]
#   (Optional) How many seconds to wait between pools when file_event_handler
#   is set.
#   Defaults to $facts['os_service_default']
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'
#
# [*manage_package*]
#   (Optional) Manage oslo.reports package.
#   Defaults to true
#
class ironic::reports (
  $log_dir                     = $facts['os_service_default'],
  $file_event_handler          = $facts['os_service_default'],
  $file_event_handler_interval = $facts['os_service_default'],
  $package_ensure              = 'present',
  Boolean $manage_package      = true,
) {
  include ironic::deps

  oslo::reports { 'ironic_config':
    log_dir                     => $log_dir,
    file_event_handler          => $file_event_handler,
    file_event_handler_interval => $file_event_handler_interval,
    package_ensure              => $package_ensure,
    manage_package              => $manage_package,
  }

  # Install the oslo.reports library before starting the ironic service
  Oslo::Reports['ironic_config'] -> Anchor['ironic::service::begin']
}
