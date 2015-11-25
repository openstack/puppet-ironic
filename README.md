puppet-ironic
=============

7.0.0 - 2015.2 - Liberty

#### Table of Contents

1. [Overview - What is the ironic module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with ironic](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)

Overview
--------

The ironic module is a part of [OpenStack](https://github.com/openstack), an effort by the Openstack infrastructure team to provide continuous integration testing and code review for Openstack and Openstack community projects as part of the core software. The module itself is used to flexibly configure and manage the baremetal service for Openstack.

Module Description
------------------

Setup
-----

**What the ironic module affects:**

* [Ironic](https://wiki.openstack.org/wiki/Ironic), the baremetal service for Openstack.

### Installing Ironic

    puppet module install openstack/ironic

### Beginning with ironic

To utilize the ironic module's functionality you will need to declare multiple resources.
The following is a modified excerpt from the [openstack module](httpd://github.com/stackforge/puppet-openstack).
This is not an exhaustive list of all the components needed. We recommend that you consult and understand the
[openstack module](https://github.com/stackforge/puppet-openstack) and the [core openstack](http://docs.openstack.org)
documentation to assist you in understanding the available deployment options.

```puppet
# enable Ironic resources
class { '::ironic':
  rabbit_userid       => 'ironic',
  rabbit_password     => 'an_even_bigger_secret',
  rabbit_host         => '127.0.0.1',
  database_connection => 'mysql://ironic:a_big_secret@127.0.0.1/ironic?charset=utf8',
}

class { '::ironic::db::mysql':
  password => 'a_big_secret',
}

class { '::ironic::keystone::auth':
  password => 'a_big_secret',
}

class { '::ironic::client': }

class { '::ironic::conductor': }

class { '::ironic::api':
  admin_password => 'a_big_secret',
}

class { '::ironic::drivers::ipmi': }

# alternatively, you can deploy Ironic with Bifrost. It's a collection of Ansible playbooks to configure
# and install Ironic in a stand-alone fashion (for more information visit http://git.openstack.org/openstack/bifrost)
class { 'ironic::bifrost':
  ironic_db_password => 'a_big_secret',
  mysql_password => 'yet_another_big_secret',
  baremetal_json_hosts => hiera('your_hiera_var_containing_bm_json_hosts'),
}
```

Examples of usage also can be found in the *examples* directory.

Implementation
--------------

### puppet-ironic

puppet-ironic is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

### Types

#### ironic_config

The `ironic_config` provider is a children of the ini_setting provider. It allows one to write an entry in the `/etc/ironic/ironic.conf` file.

```puppet
ironic_config { 'DEFAULT/verbose' :
  value => true,
}
```

This will write `verbose=true` in the `[DEFAULT]` section.

##### name

Section/setting name to manage from `ironic.conf`

##### value

The value of the setting to be defined.

##### secret

Whether to hide the value from Puppet logs. Defaults to `false`.

##### ensure_absent_val

If value is equal to ensure_absent_val then the resource will behave as if `ensure => absent` was specified. Defaults to `<SERVICE DEFAULT>`

Limitations
-----------

Beaker-Rspec
------------

This module has beaker-rspec tests

To run:

``shell
bundle install
bundle exec rspec spec/acceptance
``

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://wiki.openstack.org/wiki/Puppet-openstack#Developer_documentation

Contributors
------------

* https://github.com/openstack/puppet-ironic/graphs/contributors
