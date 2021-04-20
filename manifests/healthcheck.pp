# == Class: ironic::healthcheck
#
# Configure oslo_middleware options in healthcheck section
#
# == Params
#
# [*enabled*]
#   (Optional) Enable the healthcheck endpoint at /healthcheck.
#   Defaults to $::os_service_default
#
# [*detailed*]
#   (Optional) Show more detailed information as part of the response.
#   Defaults to $::os_service_default
#
# [*backends*]
#   (Optional) Additional backends that can perform health checks and report
#   that information back as part of a request.
#   Defaults to $::os_service_default
#
# [*disable_by_file_path*]
#   (Optional) Check the presense of a file to determine if an application
#   is running on a port.
#   Defaults to $::os_service_default
#
# [*disable_by_file_paths*]
#   (Optional) Check the presense of a file to determine if an application
#   is running on a port. Expects a "port:path" list of strings.
#   Defaults to $::os_service_default
#
class ironic::healthcheck (
  $enabled               = $::os_service_default,
  $detailed              = $::os_service_default,
  $backends              = $::os_service_default,
  $disable_by_file_path  = $::os_service_default,
  $disable_by_file_paths = $::os_service_default,
) {

  include ironic::deps

  ironic_config {
    'healthcheck/enabled': value => $enabled;
  }

  oslo::healthcheck { 'ironic_config':
    detailed              => $detailed,
    backends              => $backends,
    disable_by_file_path  => $disable_by_file_path,
    disable_by_file_paths => $disable_by_file_paths,
  }
}
