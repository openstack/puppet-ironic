# == Class: ironic::audit
#
# Configure audit middleware options
#
# == Params
#
# [*enabled*]
#   (Optional) Enable auditing of API requests
#   Defaults to $facts['os_service_default']
#
# [*audit_map_file*]
#   (Optional) Path to audit map file.
#   Defaults to $facts['os_service_default']
#
# [*ignore_req_list*]
#   (Optional) List of REST API HTTP methods to be ignored during audit
#   logging.
#   Defaults to $facts['os_service_default']
#
class ironic::audit (
  $enabled         = $facts['os_service_default'],
  $audit_map_file  = $facts['os_service_default'],
  $ignore_req_list = $facts['os_service_default'],
) {
  include ironic::deps

  ironic_config {
    'audit/enabled': value => $enabled;
  }

  oslo::audit { 'ironic_config':
    audit_map_file  => $audit_map_file,
    ignore_req_list => $ignore_req_list,
  }
}
