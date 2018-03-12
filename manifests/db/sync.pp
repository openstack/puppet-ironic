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

  # NOTE(dtantsur): previous ironic-dbsync was run as root. it will fail to run
  # as "ironic" user, if there is an old log file owned by root. Let's fix it.
  # To be removed in Rocky.
  file { '/var/log/ironic/ironic-dbsync.log':
    ensure  => 'present',
    owner   => 'ironic',
    group   => 'ironic',
    # /var/log/ironic comes from ironic-common
    require => Anchor['ironic::install::end']
  }

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
    require     => File['/var/log/ironic/ironic-dbsync.log'],
    tag         => 'openstack-db',
  }
}
