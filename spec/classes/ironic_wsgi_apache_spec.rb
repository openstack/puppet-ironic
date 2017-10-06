require 'spec_helper'

describe 'ironic::wsgi::apache' do

  shared_examples_for 'apache serving ironic with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('ironic::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('ironic_wsgi').with(
        :bind_port           => 6385,
        :group               => 'ironic',
        :path                => '/',
        :servername          => facts[:fqdn],
        :ssl                 => true,
        :threads             => facts[:os_workers],
        :user                => 'ironic',
        :workers             => 1,
        :wsgi_daemon_process => 'ironic',
        :wsgi_process_group  => 'ironic',
        :wsgi_script_dir     => platform_params[:wsgi_script_path],
        :wsgi_script_file    => 'app',
        :wsgi_script_source  => platform_params[:wsgi_script_source],
        :access_log_file     => false,
        :access_log_format   => false,
      )}
    end

    context 'when overriding parameters using different ports' do
      let :params do
        {
          :servername                => 'dummy.host',
          :bind_host                 => '10.42.51.1',
          :port                      => 12345,
          :ssl                       => false,
          :wsgi_process_display_name => 'ironic',
          :workers                   => 37,
          :access_log_file           => '/var/log/httpd/access_log',
          :access_log_format         => 'some format',
          :error_log_file            => '/var/log/httpd/error_log'
        }
      end
      it { is_expected.to contain_class('ironic::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to_not contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('ironic_wsgi').with(
        :bind_host                 => '10.42.51.1',
        :bind_port                 => 12345,
        :group                     => 'ironic',
        :path                      => '/',
        :servername                => 'dummy.host',
        :ssl                       => false,
        :threads                   => facts[:os_workers],
        :user                      => 'ironic',
        :workers                   => 37,
        :wsgi_daemon_process       => 'ironic',
        :wsgi_process_display_name => 'ironic',
        :wsgi_process_group        => 'ironic',
        :wsgi_script_dir           => platform_params[:wsgi_script_path],
        :wsgi_script_file          => 'app',
        :wsgi_script_source        => platform_params[:wsgi_script_source],
        :access_log_file           => '/var/log/httpd/access_log',
        :access_log_format         => 'some format',
        :error_log_file            => '/var/log/httpd/error_log'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld'
        }))
      end

      let :platform_params do
        case facts[:osfamily]
        when 'Debian'
            {
              :httpd_service_name => 'apache2',
              :httpd_ports_file   => '/etc/apache2/ports.conf',
              :wsgi_script_path   => '/usr/lib/cgi-bin/ironic',
              :wsgi_script_source => '/usr/lib/python2.7/dist-packages/ironic/api/app.wsgi',
            }
        when 'RedHat'
            {
              :httpd_service_name => 'httpd',
              :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
              :wsgi_script_path   => '/var/www/cgi-bin/ironic',
              :wsgi_script_source => '/usr/lib/python2.7/site-packages/ironic/api/app.wsgi',
            }
        end
      end

      it_behaves_like 'apache serving ironic with mod_wsgi'

    end
  end

end
