# == Class: ironic::inspector::config
#
# This class is used to manage arbitrary Ironic-inspector configurations.
#
# === Parameters
#
# [*ironic_inspector_config*]
#   (optional) Allow configuration of arbitrary Ironic-inspector configurations.
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
class ironic::inspector::config (
  Hash $ironic_inspector_config = {},
) {

  include ironic::deps

  create_resources('ironic_inspector_config', $ironic_inspector_config)
}
