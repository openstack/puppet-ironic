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
# Unit tests for ironic::inspector::swift
#

require 'spec_helper'

describe 'ironic::inspector::swift' do

  let :default_params do
    { :auth_type    => 'password',
      :project_name => 'services',
      :username     => 'ironic',
    }
  end

  let :params do
    {}
  end

  shared_examples_for 'ironic-inspector swift configuration' do
    let :p do
      default_params.merge(params)
    end

    it 'configures ironic-inspector.conf' do
      is_expected.to contain_ironic_inspector_config('swift/auth_type').with_value(p[:auth_type])
      is_expected.to contain_ironic_inspector_config('swift/auth_url').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('swift/project_name').with_value(p[:project_name])
      is_expected.to contain_ironic_inspector_config('swift/username').with_value(p[:username])
      is_expected.to contain_ironic_inspector_config('swift/password').with_value('<SERVICE DEFAULT>').with_secret(true)
      is_expected.to contain_ironic_inspector_config('swift/user_domain_name').with_value('Default')
      is_expected.to contain_ironic_inspector_config('swift/project_domain_name').with_value('Default')
      is_expected.to contain_ironic_inspector_config('swift/region_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('swift/endpoint_override').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('swift/container').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('swift/delete_after').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
            :auth_type           => 'noauth',
            :auth_url            => 'http://example.com',
            :project_name        => 'project1',
            :username            => 'admin',
            :password            => 'pa$$w0rd',
            :user_domain_name    => 'NonDefault',
            :project_domain_name => 'NonDefault',
            :region_name         => 'regionTwo',
            :endpoint_override   => 'http://example2.com',
            :container           => 'mycontainer',
            :delete_after        => 0,
        )
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_inspector_config('swift/auth_type').with_value(p[:auth_type])
        is_expected.to contain_ironic_inspector_config('swift/auth_url').with_value(p[:auth_url])
        is_expected.to contain_ironic_inspector_config('swift/project_name').with_value(p[:project_name])
        is_expected.to contain_ironic_inspector_config('swift/username').with_value(p[:username])
        is_expected.to contain_ironic_inspector_config('swift/password').with_value(p[:password]).with_secret(true)
        is_expected.to contain_ironic_inspector_config('swift/user_domain_name').with_value(p[:user_domain_name])
        is_expected.to contain_ironic_inspector_config('swift/project_domain_name').with_value(p[:project_domain_name])
        is_expected.to contain_ironic_inspector_config('swift/region_name').with_value(p[:region_name])
        is_expected.to contain_ironic_inspector_config('swift/endpoint_override').with_value(p[:endpoint_override])
        is_expected.to contain_ironic_inspector_config('swift/container').with_value(p[:container])
        is_expected.to contain_ironic_inspector_config('swift/delete_after').with_value(0)
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

      it_behaves_like 'ironic-inspector swift configuration'
    end
  end

end
