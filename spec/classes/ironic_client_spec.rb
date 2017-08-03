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
# Unit tests for ironic::client
#

require 'spec_helper'

describe 'ironic::client' do

  shared_examples_for 'ironic client' do

    it { is_expected.to contain_class('ironic::deps') }
    it { is_expected.to contain_class('ironic::params') }

    it 'installs ironic client package' do
      is_expected.to contain_package('python-ironicclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package],
        :tag    => ['openstack', 'ironic-support-package']
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

      let :platform_params do
        { :client_package => 'python-ironicclient' }
      end

      it_behaves_like 'ironic client'
    end
  end

end
