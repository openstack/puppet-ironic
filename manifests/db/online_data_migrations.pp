#
# Class to execute ironic online_data_migrations
#
# ==Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the ironic-dbsync command.
#   Defaults to undef
#
# [*migration_params*]
#   (optional) String of extra command line parameters to pass to migrations.
#   Unlike extra_params, these apply to migrations themselves, not to the
#   ironic-dbsync command.
#   Defaults to undef
#
class ironic::db::online_data_migrations(
  $extra_params     = undef,
  $migration_params = undef,
) {

  include ::ironic::deps
  include ::ironic::params

  exec { 'ironic-db-online-data-migrations':
    command     => "${::ironic::params::dbsync_command} ${extra_params} online_data_migrations ${migration_params}",
    path        => '/usr/bin',
    user        => 'ironic',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['ironic::install::end'],
      Anchor['ironic::config::end'],
      Anchor['ironic::dbsync::end'],
      Anchor['ironic::db_online_data_migrations::begin']
    ],
    notify      => Anchor['ironic::db_online_data_migrations::end'],
  }
}
