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
# Unit tests for ironic::drivers::deploy class
#

require 'spec_helper'

describe 'ironic::drivers::deploy' do

  shared_examples_for 'ironic deploy utils' do

    context 'with default parameters' do
      it { is_expected.to contain_ironic_config('deploy/http_url').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_config('deploy/http_root').with_value('<SERVICE DEFAULT>') }
    end

    context 'when overriding parameters' do
      let :params do
        { :http_url  => 'http://foo',
          :http_root => '/httpboot' }
      end

      it { is_expected.to contain_ironic_config('deploy/http_url').with_value('http://foo') }
      it { is_expected.to contain_ironic_config('deploy/http_root').with_value('/httpboot') }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :processorcount => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end
      it_configures 'ironic deploy utils'
    end
  end

end
