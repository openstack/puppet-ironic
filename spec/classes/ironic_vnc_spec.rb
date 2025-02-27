require 'spec_helper'

describe 'ironic::vnc' do

  shared_examples_for 'ironic::vnc' do
    context 'with defaults' do
      it { is_expected.to contain_class('ironic::params') }

      it 'installs ironic novncproxy package' do
        if platform_params.has_key?(:novncproxy_package)
          is_expected.to contain_package('ironic-novncproxy').with(
            :ensure => 'present',
            :name   => platform_params[:novncproxy_package],
            :tag    => ['openstack', 'ironic-package'],
          )
        end
      end

      it 'ensure ironic novncproxy service is running' do
        if platform_params.has_key?(:novncproxy_service)
          is_expected.to contain_service('ironic-novncproxy').with(
            :ensure    => 'running',
            :name      => platform_params[:novncproxy_service],
            :enable    => true,
            :hasstatus => true,
            :tag       => 'ironic-service',
          )
        end
      end

      it 'configures ironic.conf' do
        is_expected.to contain_ironic_config('vnc/enabled').with_value(true)
        is_expected.to contain_ironic_config('vnc/host_ip').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('vnc/port').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('vnc/public_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('vnc/enable_ssl').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('vnc/novnc_web').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('vnc/novnc_record').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('vnc/novnc_auth_schemes').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('vnc/token_timeout').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters' do
      let :params do
        {
          :enabled            => false,
          :host_ip            => '0.0.0.0',
          :port               => 6090,
          :public_url         => 'http://192.0.2.11:6090/vnc_auto.html',
          :enable_ssl         => false,
          :novnc_web          => '/usr/share/novnc',
          :novnc_record       => 'recordfile',
          :novnc_auth_schemes => 'none',
          :token_timeout      => 600,
        }
      end

      it 'installs ironic novncproxy package' do
        if platform_params.has_key?(:novncproxy_package)
          is_expected.to contain_package('ironic-novncproxy').with(
            :name   => platform_params[:novncproxy_package],
            :ensure => 'present',
            :tag    => ['openstack', 'ironic-package'],
          )
        end
      end

      it 'ensure ironic novncproxy service is stopped' do
        if platform_params.has_key?(:novncproxy_service)
          is_expected.to contain_service('ironic-novncproxy').with(
            :ensure    => 'stopped',
            :enable    => false,
            :hasstatus => true,
            :tag       => 'ironic-service',
          )
        end
      end

      it 'configures ironic.conf' do
        is_expected.to contain_ironic_config('vnc/enabled').with_value(false)
        is_expected.to contain_ironic_config('vnc/host_ip').with_value('0.0.0.0')
        is_expected.to contain_ironic_config('vnc/port').with_value(6090)
        is_expected.to contain_ironic_config('vnc/public_url').with_value('http://192.0.2.11:6090/vnc_auto.html')
        is_expected.to contain_ironic_config('vnc/enable_ssl').with_value(false)
        is_expected.to contain_ironic_config('vnc/novnc_web').with_value('/usr/share/novnc')
        is_expected.to contain_ironic_config('vnc/novnc_record').with_value('recordfile')
        is_expected.to contain_ironic_config('vnc/novnc_auth_schemes').with_value('none')
        is_expected.to contain_ironic_config('vnc/token_timeout').with_value(600)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

        case facts[:os]['family']
        when 'Debian'
          let :platform_params do
            {}
          end
        when 'RedHat'
          let :platform_params do
            { :novncproxy_service => 'openstack-ironic-novncproxy',
              :novncproxy_package => 'openstack-ironic-novncproxy' }
          end
        end

      it_behaves_like 'ironic::vnc'
    end
  end

end
