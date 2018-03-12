#
# Class to execute ironic-inspector dbsync
#
class ironic::inspector::db::sync {

  include ::ironic::deps
  include ::ironic::params

  exec { 'ironic-inspector-dbsync':
    command     => $::ironic::params::inspector_dbsync_command,
    path        => '/usr/bin',
    user        => 'ironic-inspector',
    refreshonly => true,
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
