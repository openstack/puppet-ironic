#
# Class to execute ironic dbsync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the ironic-dbsync command.
#   Defaults to undef
#
class ironic::db::sync(
  $extra_params  = undef,
) {

  include ::ironic::deps
  include ::ironic::params

  exec { 'ironic-dbsync':
    command     => "${::ironic::params::dbsync_command} ${extra_params}",
    path        => '/usr/bin',
    user        => 'ironic',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['ironic::install::end'],
      Anchor['ironic::config::end'],
      Anchor['ironic::dbsync::begin']
    ],
    notify      => Anchor['ironic::dbsync::end'],
  }
}
