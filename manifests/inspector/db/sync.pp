#
# Class to execute ironic-inspector dbsync
#
# == Parameters
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class ironic::inspector::db::sync (
  $db_sync_timeout = 300,
) {
  include ironic::deps
  include ironic::params

  exec { 'ironic-inspector-dbsync':
    command     => $ironic::params::inspector_dbsync_command,
    path        => '/usr/bin',
    user        => $ironic::params::inspector_user,
    refreshonly => true,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['ironic-inspector::install::end'],
      Anchor['ironic-inspector::config::end'],
      Anchor['ironic-inspector::dbsync::begin']
    ],
    notify      => Anchor['ironic-inspector::dbsync::end'],
    tag         => 'openstack-db',
  }
}
