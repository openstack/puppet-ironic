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
# Unit tests for ironic::drivers::drac class
#

require 'spec_helper'

describe 'ironic::drivers::drac' do

  let :params do
    {}
  end

  shared_examples_for 'ironic drac driver' do

    it 'installs sushy-oem-idrac package' do
      is_expected.to contain_package('python-sushy-oem-idrac').with(
        :ensure => 'present',
        :name   => platform_params[:sushy_oem_idrac_package_name],
        :tag    => ['openstack', 'ironic-package'],
      )
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
        case facts[:os]['family']
        when 'Debian'
          { :sushy_oem_idrac_package_name => 'python3-sushy-oem-idrac' }
        when 'RedHat'
          { :sushy_oem_idrac_package_name => 'python3-sushy-oem-idrac' }
        end
      end

      it_behaves_like 'ironic drac driver'
    end
  end

end
