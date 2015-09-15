require 'spec_helper_acceptance'

describe 'basic ironic' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      # Common resources
      case $::osfamily {
        'Debian': {
          include ::apt
          class { '::openstack_extras::repo::debian::ubuntu':
            release         => 'liberty',
            repo            => 'proposed',
            package_require => true,
          }
          $package_provider = 'apt'
        }
        'RedHat': {
          class { '::openstack_extras::repo::redhat::redhat':
            manage_rdo => false,
            repo_hash => {
              'openstack-common-testing' => {
                'baseurl'  => 'http://cbs.centos.org/repos/cloud7-openstack-common-testing/x86_64/os/',
                'descr'    => 'openstack-common-testing',
                'gpgcheck' => 'no',
              },
              'openstack-liberty-testing' => {
                'baseurl'  => 'http://cbs.centos.org/repos/cloud7-openstack-liberty-testing/x86_64/os/',
                'descr'    => 'openstack-liberty-testing',
                'gpgcheck' => 'no',
              },
              'openstack-liberty-trunk' => {
                'baseurl'  => 'http://trunk.rdoproject.org/centos7-liberty/current-passed-ci/',
                'descr'    => 'openstack-liberty-trunk',
                'gpgcheck' => 'no',
              },
            },
          }
          $package_provider = 'yum'
          package { 'openstack-selinux': ensure => 'latest' }
        }
        default: {
          fail("Unsupported osfamily (${::osfamily})")
        }
      }

      class { '::mysql::server': }

      class { '::rabbitmq':
        delete_guest_user => true,
        package_provider  => $package_provider,
      }

      rabbitmq_vhost { '/':
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user { 'ironic':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'ironic@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }


      # Keystone resources, needed by Ironic to run
      class { '::keystone::db::mysql':
        password => 'keystone',
      }
      class { '::keystone':
        verbose             => true,
        debug               => true,
        database_connection => 'mysql://keystone:keystone@127.0.0.1/keystone',
        admin_token         => 'admin_token',
        enabled             => true,
      }
      class { '::keystone::roles::admin':
        email    => 'test@example.tld',
        password => 'a_big_secret',
      }
      class { '::keystone::endpoint':
        public_url => "https://${::fqdn}:5000/",
        admin_url  => "https://${::fqdn}:35357/",
      }


      # Ironic resources
      class { '::ironic':
        rabbit_userid       => 'ironic',
        rabbit_password     => 'an_even_bigger_secret',
        rabbit_host         => '127.0.0.1',
        database_connection => 'mysql://ironic:a_big_secret@127.0.0.1/ironic?charset=utf8',
        debug               => true,
        verbose             => true,
        enabled_drivers     => ['pxe_ssh'],
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

      # Ironic inspector resources
      case $::osfamily {
        'Debian': {
          warning("Ironic inspector packaging is not ready on ${::osfamily}.")
        }
        'RedHat': {
          class { '::ironic::inspector':
            auth_uri        => "https://${::fqdn}:5000/v2.0",
            identity_uri    => "https://${::fqdn}:35357",
            admin_password  => 'a_big_secret',
            ironic_password => 'a_big_secret',
            ironic_auth_url => "https://${::fqdn}:5000/v2.0",
            dnsmasq_interface => 'eth0',
          }
        }
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    if os[:family].casecmp('RedHat') == 0
      # Ironic API port
      describe port(6385) do
        it { is_expected.to be_listening.with('tcp') }
      end
      # Inspector API port
      describe port(5050) do
        it { is_expected.to be_listening.with('tcp') }
      end
    else # Inspector is not packaged, so only test Ironic
      # Ironic API port
      describe port(6385) do
        it { is_expected.to be_listening.with('tcp') }
      end
    end

  end
end
