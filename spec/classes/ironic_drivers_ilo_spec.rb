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
# Unit tests for ironic::drivers::ilo class
#

require 'spec_helper'

describe 'ironic::drivers::ilo' do

  let :params do
    {}
  end

  shared_examples_for 'ironic ilo driver' do
    let :p do
      params
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('ilo/client_timeout').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('ilo/client_port').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('ilo/use_web_server_for_images').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('ilo/default_boot_mode').with_value('<SERVICE DEFAULT>')
    end

    it 'installs proliantutils package' do
      is_expected.to contain_package('python-proliantutils').with(
        :ensure => 'present',
        :name   => platform_params[:proliantutils_package_name],
        :tag    => ['openstack', 'ironic-package'],
      )
    end

    context 'when overriding parameters' do
      before do
        params.merge!(:client_timeout            => 120,
                      :client_port               => 8888,
                      :use_web_server_for_images => true,
                      :default_boot_mode         => 'bios')
      end
      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('ilo/client_timeout').with_value(120)
        is_expected.to contain_ironic_config('ilo/client_port').with_value(8888)
        is_expected.to contain_ironic_config('ilo/use_web_server_for_images').with_value(true)
        is_expected.to contain_ironic_config('ilo/default_boot_mode').with_value('bios')
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
          { :proliantutils_package_name => 'python3-proliantutils' }
        when 'RedHat'
          if facts[:operatingsystem] == 'Fedora'
            { :proliantutils_package_name => 'python3-proliantutils' }
          else
            if facts[:operatingsystemmajrelease] > '7'
              { :proliantutils_package_name => 'python3-proliantutils' }
            else
              { :proliantutils_package_name => 'python-proliantutils' }
            end
          end
        end
      end

      it_behaves_like 'ironic ilo driver'
    end
  end

end
