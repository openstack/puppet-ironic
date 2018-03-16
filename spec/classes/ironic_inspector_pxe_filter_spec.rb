#
# Copyright (C) 2018 Red Hat, Inc
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
# Unit tests for ironic::inspector::pxe_filter class
#

require 'spec_helper'

describe 'ironic::inspector::pxe_filter' do
  let :pre_condition do
     "class { 'ironic::inspector::authtoken':
        password => 'password',
      }"
  end

  shared_examples_for 'ironic inspector pxe_filter' do
    it 'configure pxe_filter default params' do
      is_expected.to contain_ironic_inspector_config('pxe_filter/driver').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('pxe_filter/sync_period').with_value('<SERVICE DEFAULT>')
    end

    context 'with specific parameters' do
      let :params do
        { :driver      => 'dnsmasq',
          :sync_period => '30',
        }
      end

      let :p do
        params
      end

      it 'configure pxe_filter specific params' do
        is_expected.to contain_ironic_inspector_config('pxe_filter/driver').with_value(p[:driver])
        is_expected.to contain_ironic_inspector_config('pxe_filter/sync_period').with_value(p[:sync_period])
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

      it_behaves_like 'ironic inspector pxe_filter'
    end
  end

end