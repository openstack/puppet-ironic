# == Class: ironic::policy
#
# Configure the ironic policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for ironic
#   Example : { 'ironic-context_is_admin' => {'context_is_admin' => 'true'}, 'ironic-default' => {'default' => 'rule:admin_or_owner'} }
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

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path => $policy_path,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'ironic_config': policy_file => $policy_path }

}
