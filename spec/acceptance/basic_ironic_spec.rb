require 'spec_helper_acceptance'

describe 'basic ironic' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

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
