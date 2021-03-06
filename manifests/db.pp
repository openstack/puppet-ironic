# == Class: ironic::db
#
#  Configure the Ironic database
#
# === Parameters
#
# [*database_connection*]
#   Url used to connect to database.
#   (Optional) Defaults to 'sqlite:////var/lib/ironic/ovs.sqlite'.
#
# [*database_connection_recycle_time*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to $::os_service_default
#
# [*database_max_retries*]
#   Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to $::os_service_default
#
# [*database_retry_interval*]
#   Interval between retries of opening a sql connection.
#   (Optional) Defaults to $::os_service_default
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $::os_service_default
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to $::os_service_default
#
# [*database_db_max_retries*]
#   (Optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $::os_service_default
#
# [*database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $::os_service_default
#
# [*mysql_enable_ndb*]
#   (Optional) If True, transparently enables support for handling MySQL
#   Cluster (NDB).
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to undef
#
class ironic::db (
  $database_connection              = 'sqlite:////var/lib/ironic/ovs.sqlite',
  $database_connection_recycle_time = $::os_service_default,
  $database_max_retries             = $::os_service_default,
  $database_retry_interval          = $::os_service_default,
  $database_max_pool_size           = $::os_service_default,
  $database_max_overflow            = $::os_service_default,
  $database_db_max_retries          = $::os_service_default,
  $database_pool_timeout            = $::os_service_default,
  $mysql_enable_ndb                 = $::os_service_default,
  # DEPRECATED PARAMETERS
  $database_min_pool_size           = undef,
) {

  include ironic::deps

  if $::ironic::database_min_pool_size or $database_min_pool_size {
    warning('The database_min_pool_size parameter is deprecated, and will be removed in a future release.')
  }

  # NOTE(spredzy): In order to keep backward compatibility we rely on the pick function
  # to use ironic::<myparam> if ironic::db::<myparam> isn't specified.
  $database_connection_real = pick($::ironic::database_connection, $database_connection)
  $database_connection_recycle_time_real = pick($::ironic::database_idle_timeout,
                                                $database_connection_recycle_time)
  $database_max_retries_real = pick($::ironic::database_max_retries, $database_max_retries)
  $database_retry_interval_real = pick($::ironic::database_retry_interval, $database_retry_interval)
  $database_max_pool_size_real = pick($::ironic::database_max_pool_size, $database_max_pool_size)
  $database_max_overflow_real = pick($::ironic::database_max_overflow, $database_max_overflow)

  oslo::db { 'ironic_config':
    connection              => $database_connection_real,
    connection_recycle_time => $database_connection_recycle_time_real,
    max_pool_size           => $database_max_pool_size_real,
    max_retries             => $database_max_retries_real,
    retry_interval          => $database_retry_interval_real,
    max_overflow            => $database_max_overflow_real,
    db_max_retries          => $database_db_max_retries,
    pool_timeout            => $database_pool_timeout,
    mysql_enable_ndb        => $mysql_enable_ndb,
  }

}
