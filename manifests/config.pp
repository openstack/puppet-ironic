# == Class: ironic::config
#
# This class is used to manage arbitrary Ironic configurations.
#
# === Parameters
#
# [*ironic_config*]
#   (optional) Allow configuration of arbitrary Ironic configurations.
#   The value is an hash of ironic_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   ironic_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [*ironic_api_paste_ini*]
#   (optional) Allow configuration of /etc/ironic/api-paste.ini options.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class ironic::config (
  $ironic_config        = {},
  $ironic_api_paste_ini = {},
) {

  include ::ironic::deps
  validate_hash($ironic_config)
  validate_hash($ironic_api_paste_ini)

  create_resources('ironic_config', $ironic_config)
  create_resources('ironic_api_paste_ini', $ironic_api_paste_ini)
}
