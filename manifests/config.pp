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
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class ironic::config (
  $ironic_config        = {},
) {

  validate_hash($ironic_config)

  create_resources('ironic_config', $ironic_config)
}
