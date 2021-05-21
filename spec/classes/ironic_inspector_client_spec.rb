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
# Unit tests for ironic::inspector::client
#
require 'spec_helper'

describe 'ironic::inspector::client' do

 let :params do
    {}
  end

  let :default_params do
    { :package_ensure   => 'present' }
  end

  shared_examples_for 'inspector client' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('ironic::deps') }
    it { is_expected.to contain_class('ironic::params') }

    it 'installs ironic inspector client package' do
      is_expected.to contain_package('python-ironic-inspector-client').with(
        :ensure => 'present',
        :name   => platform_params[:inspector_client_package],
        :tag    => ['openstack', 'ironic-support-package'],
      )
    end

    it { is_expected.to contain_class('openstacklib::openstackclient') }
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
          { :inspector_client_package => 'python3-ironic-inspector-client' }
        when 'RedHat'
          { :inspector_client_package => 'python3-ironic-inspector-client' }
        end
      end

      it_configures 'inspector client'
    end
  end

end
