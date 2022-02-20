#
# Class to execute ironic dbsync
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the ironic-dbsync command.
#   Defaults to undef
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class ironic::db::sync(
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {

  include ironic::deps
  include ironic::params

  # NOTE(dtantsur): previous ironic-dbsync was run as root. it will fail to run
  # as "ironic" user, if there is an old log file owned by root. Let's fix it.
  # To be removed in Rocky.
  file { '/var/log/ironic/ironic-dbsync.log':
    ensure  => 'present',
    owner   => $::ironic::params::user,
    group   => $::ironic::params::group,
    # /var/log/ironic comes from ironic-common
    require => Anchor['ironic::install::end']
  }

  exec { 'ironic-dbsync':
    command     => "${::ironic::params::dbsync_command} ${extra_params}",
    path        => '/usr/bin',
    user        => $::ironic::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['ironic::install::end'],
      Anchor['ironic::config::end'],
      Anchor['ironic::dbsync::begin']
    ],
    notify      => Anchor['ironic::dbsync::end'],
    require     => File['/var/log/ironic/ironic-dbsync.log'],
    tag         => 'openstack-db',
  }
}
