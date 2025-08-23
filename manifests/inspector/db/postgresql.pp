# == Class: ironic::db::postgresql
#
# Class that configures postgresql for ironic-inspector
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'ironic-inspector'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'ironic-inspector'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class ironic::inspector::db::postgresql (
  $password,
  $dbname     = 'ironic-inspector',
  $user       = 'ironic-inspector',
  $encoding   = undef,
  $privileges = 'ALL',
) {
  include ironic::deps

  openstacklib::db::postgresql { 'ironic-inspector':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['ironic-inspector::db::begin']
  ~> Class['ironic::inspector::db::postgresql']
  ~> Anchor['ironic-inspector::db::end']
}
