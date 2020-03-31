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
# Unit tests for ironic::drivers::redfish class
#

require 'spec_helper'

describe 'ironic::drivers::redfish' do

  let :params do
    {}
  end

  shared_examples_for 'ironic redfish driver' do
    let :p do
      params
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('redfish/connection_attempts').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('redfish/connection_retry_interval').with_value('<SERVICE DEFAULT>')
    end

    it 'installs sushy package' do
      is_expected.to contain_package('python-sushy').with(
        :ensure => 'present',
        :name   => platform_params[:sushy_package_name],
        :tag    => ['openstack', 'ironic-package'],
      )
    end

    context 'when overriding parameters' do
      before do
        params.merge!(:connection_attempts       => 10,
                      :connection_retry_interval => 1)
      end
      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('redfish/connection_attempts').with_value(10)
        is_expected.to contain_ironic_config('redfish/connection_retry_interval').with_value(1)
      end
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :sushy_package_name => 'python3-sushy' }
        when 'RedHat'
          if facts[:operatingsystem] == 'Fedora'
            { :sushy_package_name => 'python3-sushy' }
          else
            if facts[:operatingsystemmajrelease] > '7'
              { :sushy_package_name => 'python3-sushy' }
            else
              { :sushy_package_name => 'python-sushy' }
            end
          end
        end
      end

      it_behaves_like 'ironic redfish driver'
    end
  end

end
