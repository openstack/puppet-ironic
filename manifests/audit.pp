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
#   (Optional) Path to audit map file for ironic-api service.
#   Defaults to $facts['os_service_default']
#
# [*ignore_req_list*]
#   (Optional) Comma separated list of Ironic REST API HTTP methods
#   to be ignored during audit logging.
#   Defaults to $facts['os_service_default']
#
class ironic::audit (
  $enabled         = $facts['os_service_default'],
  $audit_map_file  = $facts['os_service_default'],
  $ignore_req_list = $facts['os_service_default'],
) {

  include ironic::deps

  ironic_config {
    'audit/enabled':         value => $enabled;
    'audit/audit_map_file':  value => $audit_map_file;
    'audit/ignore_req_list': value => join(any2array($ignore_req_list), ',');
  }
}
