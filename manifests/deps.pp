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

  # paste-api.ini config should occur in the config block also.
  Anchor['ironic::config::begin']
  -> Ironic_api_paste_ini<||>
  ~> Anchor['ironic::config::end']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['ironic::dbsync::begin']

  # ironic-inspector is supported by this module.  This service uses a
  # specific conf file and uses it's own config provider. Split out install
  # and configure of this service so that other services are not affected.
  anchor { 'ironic-inspector::install::begin': }
  -> Package<| tag == 'ironic-inspector-package'|>
  ~> anchor { 'ironic-inspector::install::end': }
  -> anchor { 'ironic-inspector::config::begin': }
  -> Ironic_inspector_config<||>
  ~> anchor { 'ironic-inspector::config::end': }
  -> anchor { 'ironic-inspector::dbsync::begin': }
  -> anchor { 'ironic-inspector::dbsync::end': }
  ~> anchor { 'ironic-inspector::service::begin': }
  ~> Service<| tag == 'ironic-inspector-service' |>
  ~> Service<| tag == 'ironic-inspector-dnsmasq-service' |>
  ~> anchor { 'ironic-inspector::service::end': }

  Anchor['ironic::db::end']
  -> Anchor['ironic-inspector::dbsync::begin']

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the ironic-package tag and the ironic-support-package
  # tag.  Note: the package resources here will have a 'before' relationshop on
  # the ironic::install::end anchor.  The line between ironic-support-package and
  # ironic-package should be whether or not ironic services would need to be
  # restarted if the package state was changed.
  Anchor['ironic::install::begin']
  -> Package<| tag == 'ironic-support-package'|>
  -> Anchor['ironic::install::end']

  # ironic-inspector depends on support packages in pxe.pp
  Anchor['ironic-inspector::install::begin']
  -> Package<| tag == 'ironic-support-package'|>
  -> Anchor['ironic-inspector::install::end']

# Installation or config changes will always restart services.
  Anchor['ironic::install::end'] ~> Anchor['ironic::service::begin']
  Anchor['ironic::config::end']  ~> Anchor['ironic::service::begin']
  Anchor['ironic-inspector::install::end'] ~> Anchor['ironic-inspector::service::begin']
  Anchor['ironic-inspector::config::end']  ~> Anchor['ironic-inspector::service::begin']
}
