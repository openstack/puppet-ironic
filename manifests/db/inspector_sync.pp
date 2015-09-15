#
# Class to execute ironic-inspector dbsync
#
class ironic::db::inspector_sync {

  include ::ironic::params

  Package<| tag == 'ironic-inspector-package' |> ~> Exec['ironic-inspector-dbsync']
  Exec['ironic-inspector-dbsync'] ~> Service <| tag == 'ironic-inspector-service' |>

  Ironic_inspector_config<||> -> Exec['ironic-inspector-dbsync']
  Ironic_inspector_config<| title == 'database/connection' |> ~> Exec['ironic-inspector-dbsync']

  exec { 'ironic-inspector-dbsync':
    command     => $::ironic::params::inspector_dbsync_command,
    path        => '/usr/bin',
    user        => 'ironic-inspector',
    refreshonly => true,
    logoutput   => on_failure,
  }
}
