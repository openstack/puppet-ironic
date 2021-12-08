Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-ironic.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

puppet-ironic
=============

#### Table of Contents

1. [Overview - What is the ironic module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with ironic](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)
8. [Release Notes - Release notes for the project](#release-notes)
9. [Repository - The project source code repository](#repository)

Overview
--------

The ironic module is a part of [OpenStack](https://opendev.org/openstack), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects as part of the core software. The module itself is used to flexibly configure and manage the baremetal service for OpenStack.

Module Description
------------------

Setup
-----

**What the ironic module affects:**

* [Ironic](https://docs.openstack.org/ironic/latest/), the baremetal service for OpenStack.

### Installing Ironic

    puppet module install openstack/ironic

### Beginning with ironic

To utilize the ironic module's functionality you will need to declare multiple resources. This is not an exhaustive list of all the components needed. We recommend that you consult and understand the [core openstack](http://docs.openstack.org) documentation to assist you in understanding the available deployment options.

```puppet
# enable Ironic resources
class { 'ironic':
  default_transport_url => 'rabbit://ironic:an_even_bigger_secret@127.0.0.1:5672/ironic',
  database_connection   => 'mysql://ironic:a_big_secret@127.0.0.1/ironic?charset=utf8',
}

class { 'ironic::db::mysql':
  password => 'a_big_secret',
}

class { 'ironic::keystone::auth':
  password => 'a_big_secret',
}

class { 'ironic::client': }

class { 'ironic::conductor': }

class { 'ironic::api':
  admin_password => 'a_big_secret',
}

class { 'ironic::drivers::ipmi': }

Examples of usage also can be found in the *examples* directory.

Implementation
--------------

### puppet-ironic

puppet-ironic is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

### Types

#### ironic_config

The `ironic_config` provider is a children of the ini_setting provider. It allows one to write an entry in the `/etc/ironic/ironic.conf` file.

```puppet
ironic_config { 'DEFAULT/my_ip' :
  value => 127.0.0.1,
}
```

This will write `my_ip=127.0.0.1` in the `[DEFAULT]` section.

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

None

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------

* https://github.com/openstack/puppet-ironic/graphs/contributors

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-ironic

Repository
----------

* https://opendev.org/openstack/puppet-ironic
