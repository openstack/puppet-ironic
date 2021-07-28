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
# Unit tests for ironic::json_rpc
#

require 'spec_helper'

describe 'ironic::json_rpc' do

  let :default_params do
    { :auth_strategy => 'keystone',
      :auth_type     => 'password',
      :project_name  => 'service',
      :use_ssl       => false,
      :username      => 'ironic',
    }
  end

  let :params do
    {}
  end

  shared_examples_for 'ironic json_rpc configuration' do
    let :p do
      default_params.merge(params)
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('json_rpc/auth_strategy').with_value(p[:auth_strategy])
      is_expected.to contain_ironic_config('json_rpc/http_basic_auth_user_file').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('json_rpc/host_ip').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('json_rpc/port').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('json_rpc/use_ssl').with_value(p[:use_ssl])
      is_expected.to contain_ironic_config('json_rpc/auth_type').with_value(p[:auth_type])
      is_expected.to contain_ironic_config('json_rpc/auth_url').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('json_rpc/project_name').with_value(p[:project_name])
      is_expected.to contain_ironic_config('json_rpc/username').with_value(p[:username])
      is_expected.to contain_ironic_config('json_rpc/password').with_value('<SERVICE DEFAULT>').with_secret(true)
      is_expected.to contain_ironic_config('json_rpc/user_domain_name').with_value('Default')
      is_expected.to contain_ironic_config('json_rpc/project_domain_name').with_value('Default')
      is_expected.to contain_ironic_config('json_rpc/endpoint_override').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :auth_strategy     => 'http_basic',
          :auth_type         => 'http_basic',
          :endpoint_override => 'http://example.com',
          :username          => 'admin',
          :password          => 'pa$$w0rd',
        )
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('json_rpc/auth_strategy').with_value(p[:auth_strategy])
        is_expected.to contain_ironic_config('json_rpc/auth_type').with_value(p[:auth_type])
        is_expected.to contain_ironic_config('json_rpc/username').with_value(p[:username])
        is_expected.to contain_ironic_config('json_rpc/password').with_value(p[:password]).with_secret(true)
        is_expected.to contain_ironic_config('json_rpc/endpoint_override').with_value(p[:endpoint_override])
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

      it_behaves_like 'ironic json_rpc configuration'
    end
  end

end
