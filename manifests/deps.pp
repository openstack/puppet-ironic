# == Class: ironic::deps
#
#  ironic anchors and dependency management
#
class ironic::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'ironic::install::begin': }
  -> Package<| tag == 'ironic-package'|>
  ~> anchor { 'ironic::install::end': }
  -> anchor { 'ironic::config::begin': }
  -> Ironic_config<||>
  ~> anchor { 'ironic::config::end': }
  -> anchor { 'ironic::db::begin': }
  -> anchor { 'ironic::db::end': }
  ~> anchor { 'ironic::dbsync::begin': }
  -> anchor { 'ironic::dbsync::end': }
  ~> anchor { 'ironic::db_online_data_migrations::begin': }
  -> anchor { 'ironic::db_online_data_migrations::end': }
  ~> anchor { 'ironic::service::begin': }
  ~> Service<| tag == 'ironic-service' |>
  ~> anchor { 'ironic::service::end': }

  Anchor['ironic::config::begin']
  -> Ironic_api_uwsgi_config<||>
  -> Anchor['ironic::config::end']

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the ironic-package tag and the ironic-support-package
  # tag.  Note: the package resources here will have a 'before' relationship on
  # the ironic::install::end anchor.  The line between ironic-support-package and
  # ironic-package should be whether or not ironic services would need to be
  # restarted if the package state was changed.
  Anchor['ironic::install::begin']
  -> Package<| tag == 'ironic-support-package'|>
  -> Anchor['ironic::install::end']

  # openstackclient package is needed by transform
  Package<| tag == 'openstackclient'|>
  -> Anchor['ironic::config::begin']

  # Installation or config changes will always restart services.
  Anchor['ironic::install::end'] ~> Anchor['ironic::service::begin']
  Anchor['ironic::config::end']  ~> Anchor['ironic::service::begin']
}
