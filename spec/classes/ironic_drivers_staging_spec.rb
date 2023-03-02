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
# Unit tests for ironic::drivers::staging
#
require 'spec_helper'

describe 'ironic::drivers::staging' do

 let :params do
    {}
  end

  let :default_params do
    { :package_ensure   => 'present' }
  end

  shared_examples_for 'ironic-staging-drivers' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('ironic::deps') }
    it { is_expected.to contain_class('ironic::params') }

    it 'installs ironic-staging-drivers package' do
      is_expected.to contain_package('ironic-staging-drivers').with(
        :ensure => 'present',
        :name   => 'openstack-ironic-staging-drivers',
        :tag    => ['openstack', 'ironic-support-package'],
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      if facts[:os]['family'] == 'RedHat'
        it_configures 'ironic-staging-drivers'
      end
    end
  end

end
