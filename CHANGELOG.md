## 8.0.0 and beyond

From 8.0.0 release and beyond, release notes are published on
[docs.openstack.org](http://docs.openstack.org/releasenotes/puppet-ironic/).

##2015-11-25 - 7.0.0
###Summary

This is a backwards-incompatible major release for OpenStack Liberty.

####Backwards-incompatible changes
- change section name for AMQP qpid parameters
- change section name for AMQP rabbit parameters

####Features
- add ironic::db::sync
- add bifrost manifest
- reflect provider change in puppet-openstacklib
- put all the logging related parameters to the logging class
- add ironic-inspector support
- simplify rpc_backend parameter
- introduce ironic::db class
- db: Use postgresql lib class for psycopg package
- allow customization of db sync command line
- allow customization of force_power_state_during_sync
- add ironic::config class
- add tag to package and service resources
- add support for identity_uri

####Bugfixes
- rely on autorequire for config resource ordering
- fixed the comment for port in ironic api.pp
- add BOOTIF=${mac} to the inspector iPXE template

####Maintenance
- acceptance: enable debug & verbosity for OpenStack logs
- initial msync run for all Puppet OpenStack modules
- fix rspec 3.x syntax
- acceptance: install openstack-selinux on redhat plateforms
- try to use zuul-cloner to prepare fixtures
- remove class_parameter_defaults puppet-lint check
- acceptance: use common bits from puppet-openstack-integration

##2015-10-14 - 6.1.0
###Summary

This is a feature and maintenance release in the Kilo series.

####Features
- Create Heat Domain with Keystone_domain resource

####Maintenance
- Remove deprecated parameter stack_user_domain
- acceptance: checkout stable/kilo puppet modules

##2015-10-15 - 6.1.0
###Summary

This is a maintenance release in the Kilo series

####Maintenance
- acceptance: checkout stable/kilo puppet modules

##2015-07-08 - 6.0.0
###Summary

- Initial release of the puppet-ironic module
