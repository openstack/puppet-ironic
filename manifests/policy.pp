# == Class: ironic::policy
#
# Configure the ironic policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for ironic
#   Example :
#     {
#       'ironic-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'ironic-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the ironic policy.json file
#   Defaults to /etc/ironic/policy.json
#
class ironic::policy (
  $policies    = {},
  $policy_path = '/etc/ironic/policy.json',
) {

  include ::ironic::deps
  include ::ironic::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::ironic::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'ironic_config': policy_file => $policy_path }

}
