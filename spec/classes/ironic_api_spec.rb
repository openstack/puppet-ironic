#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Unit tests for ironic::api class
#

require 'spec_helper'

describe 'ironic::api' do
  let :pre_condition do
    "class { '::ironic::api::authtoken':
       password => 'password',
     }"
  end

  let :params do
    { :package_ensure    => 'present',
      :enabled           => true,
      :port              => '6385',
      :max_limit         => '1000',
      :host_ip           => '0.0.0.0',
    }
  end

  shared_examples_for 'ironic api' do
    let :p do
      params
    end

    it { is_expected.to contain_class('ironic::params') }
    it { is_expected.to contain_class('ironic::policy') }

    it 'installs ironic api package' do
      if platform_params.has_key?(:api_package)
        is_expected.to contain_package('ironic-api').with(
          :name   => platform_params[:api_package],
          :ensure => p[:package_ensure],
          :tag    => ['openstack', 'ironic-package'],
        )
        is_expected.to contain_package('ironic-api').that_requires('Anchor[ironic::install::begin]')
        is_expected.to contain_package('ironic-api').that_notifies('Anchor[ironic::install::end]')
      end
    end

    it 'ensure ironic api service is running' do
      is_expected.to contain_service('ironic-api').with(
        'hasstatus' => true,
        'tag'       => 'ironic-service',
      )
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('api/port').with_value(p[:port])
      is_expected.to contain_ironic_config('api/host_ip').with_value(p[:host_ip])
      is_expected.to contain_ironic_config('api/max_limit').with_value(p[:max_limit])
      is_expected.to contain_ironic_config('api/api_workers').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('api/public_endpoint').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_oslo__middleware('ironic_config').with(
        :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
        :max_request_body_size        => '<SERVICE DEFAULT>',
      )
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :port              => '3430',
          :host_ip           => '127.0.0.1',
          :max_limit         => '10',
          :workers           => '8',
          :public_endpoint   => 'https://1.2.3.4:6385/',
        )
      end
      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('api/port').with_value(p[:port])
        is_expected.to contain_ironic_config('api/host_ip').with_value(p[:host_ip])
        is_expected.to contain_ironic_config('api/max_limit').with_value(p[:max_limit])
        is_expected.to contain_ironic_config('api/api_workers').with_value(p[:workers])
        is_expected.to contain_ironic_config('api/public_endpoint').with_value(p[:public_endpoint])
      end
    end

    context 'with enable_proxy_headers_parsing' do
      before do
        params.merge!({:enable_proxy_headers_parsing => true })
      end

      it { is_expected.to contain_oslo__middleware('ironic_config').with(
        :enable_proxy_headers_parsing => true,
      )}
    end

    context 'with max_request_body_size' do
      before do
        params.merge!({:max_request_body_size => '102400' })
      end

      it { is_expected.to contain_oslo__middleware('ironic_config').with(
        :max_request_body_size => '102400',
      )}
    end

    context 'when running ironic-api in wsgi' do
      before do
        params.merge!({ :service_name => 'httpd' })
      end

      let :pre_condition do
        "class { '::ironic::api::authtoken':
           password => 'password',
         }
         include ::apache"
      end

      it 'configures ironic-api service with Apache' do
        is_expected.to contain_service('ironic-api').with(
          :ensure     => 'stopped',
          :name       => platform_params[:api_service],
          :enable     => false,
          :tag        => 'ironic-service',
        )
      end
    end

    context 'when service_name is not valid' do
      before do
        params.merge!({ :service_name => 'foobar' })
      end

      let :pre_condition do
        "class { '::ironic::api::authtoken':
           password => 'password',
         }
         include ::apache"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let :platform_params do
        case facts[:osfamily]
        when 'Debian'
          { :api_package => 'ironic-api',
            :api_service => 'ironic-api' }
        when 'RedHat'
          { :api_service => 'openstack-ironic-api' }
        end
      end

      it_behaves_like 'ironic api'
    end
  end

end
