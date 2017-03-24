ironic_config {
  'glance/swift_account':  value => 'swift_user_project', transform_to => 'project_uuid';
}
