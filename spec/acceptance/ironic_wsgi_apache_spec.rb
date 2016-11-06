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

      # https://bugs.launchpad.net/ironic/+bug/1564075
      Rabbitmq_user_permissions['ironic@/'] -> Service<| tag == 'ironic-service' |>

      # Ironic resources
      class { '::ironic':
        default_transport_url => 'rabbit://ironic:an_even_bigger_secret@127.0.0.1:5672/',
        database_connection   => 'mysql+pymysql://ironic:a_big_secret@127.0.0.1/ironic?charset=utf8',
        debug                 => true,
      }
      class { '::ironic::db::mysql':
        password => 'a_big_secret',
      }
      class { '::ironic::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::ironic::keystone::auth_inspector':
        password => 'a_big_secret',
      }
      class { '::ironic::client': }
      class { '::ironic::conductor':
        enabled_drivers     => ['pxe_ssh'],
      }
      class { '::ironic::api::authtoken':
        password => 'a_big_secret',
      }
      class { '::ironic::api':
        service_name   => 'httpd',
      }
      include ::apache
      class { '::ironic::wsgi::apache':
        ssl => false,
      }
      class { '::ironic::drivers::ipmi': }

      # Ironic inspector resources
      case $::osfamily {
        'Debian': {
          warning("Ironic inspector packaging is not ready on ${::osfamily}.")
        }
        'RedHat': {
          class { '::ironic::inspector::db::mysql':
            password => 'a_big_secret',
          }
          class { '::ironic::inspector::authtoken':
            password => 'a_big_secret',
          }
          class { '::ironic::inspector':
            ironic_password => 'a_big_secret',
            ironic_auth_url => "https://${::fqdn}:5000/v2.0",
            dnsmasq_interface => 'eth0',
            db_connection   => 'mysql+pymysql://ironic-inspector:a_big_secret@127.0.0.1/ironic-inspector?charset=utf8',
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
        it { is_expected.to be_listening }
      end
      # Inspector API port
      describe port(5050) do
        it { is_expected.to be_listening.with('tcp') }
      end
    else # Inspector is not packaged, so only test Ironic
      # Ironic API port
      describe port(6385) do
        it { is_expected.to be_listening }
      end
    end

  end
end
