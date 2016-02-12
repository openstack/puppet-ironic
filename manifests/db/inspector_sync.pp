#
# Class to execute ironic-inspector dbsync (deprecated, use
# ironic::inspector::db::sync instead).
#
class ironic::db::inspector_sync {
  warning('ironic::db::inspector_sync is deprecated, please use ironic::inspector::db::sync')

  include ::ironic::inspector::db::sync
}
