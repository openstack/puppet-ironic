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
# Unit tests for ironic::glance
#

require 'spec_helper'

describe 'ironic::glance' do

  let :params do
    { :password => 'secret' }
  end

  shared_examples_for 'ironic glance configuration' do
    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('glance/auth_type').with_value('password')
      is_expected.to contain_ironic_config('glance/auth_url').with_value('http://127.0.0.1:5000')
      is_expected.to contain_ironic_config('glance/project_name').with_value('services')
      is_expected.to contain_ironic_config('glance/username').with_value('ironic')
      is_expected.to contain_ironic_config('glance/password').with_value('secret').with_secret(true)
      is_expected.to contain_ironic_config('glance/user_domain_name').with_value('Default')
      is_expected.to contain_ironic_config('glance/project_domain_name').with_value('Default')
      is_expected.to contain_ironic_config('glance/system_scope').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('glance/region_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('glance/insecure').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('glance/num_retries').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('glance/swift_account').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('glance/swift_account_prefix').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('glance/swift_container').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('glance/swift_endpoint_url').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('glance/swift_temp_url_key').with_value('<SERVICE DEFAULT>').with_secret(true)
      is_expected.to contain_ironic_config('glance/swift_temp_url_duration').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('glance/endpoint_override').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :auth_type               => 'noauth',
          :auth_url                => 'http://example.com',
          :project_name            => 'project1',
          :username                => 'admin',
          :user_domain_name        => 'NonDefault',
          :project_domain_name     => 'NonDefault',
          :region_name             => 'regionTwo',
          :api_insecure            => true,
          :num_retries             => 42,
          :swift_account           => '00000000-0000-0000-0000-000000000000',
          :swift_account_prefix    => 'AUTH',
          :swift_container         => 'glance',
          :swift_endpoint_url      => 'http://example2.com',
          :swift_temp_url_key      => 'the-key',
          :swift_temp_url_duration => 3600,
          :endpoint_override       => 'http://example2.com',
        )
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('glance/auth_type').with_value(params[:auth_type])
        is_expected.to contain_ironic_config('glance/auth_url').with_value(params[:auth_url])
        is_expected.to contain_ironic_config('glance/project_name').with_value(params[:project_name])
        is_expected.to contain_ironic_config('glance/username').with_value(params[:username])
        is_expected.to contain_ironic_config('glance/user_domain_name').with_value(params[:user_domain_name])
        is_expected.to contain_ironic_config('glance/project_domain_name').with_value(params[:project_domain_name])
        is_expected.to contain_ironic_config('glance/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('glance/region_name').with_value(params[:region_name])
        is_expected.to contain_ironic_config('glance/insecure').with_value(params[:api_insecure])
        is_expected.to contain_ironic_config('glance/num_retries').with_value(params[:num_retries])
        is_expected.to contain_ironic_config('glance/swift_account').with_value(params[:swift_account])
        is_expected.to contain_ironic_config('glance/swift_account_prefix').with_value(params[:swift_account_prefix])
        is_expected.to contain_ironic_config('glance/swift_container').with_value(params[:swift_container])
        is_expected.to contain_ironic_config('glance/swift_endpoint_url').with_value(params[:swift_endpoint_url])
        is_expected.to contain_ironic_config('glance/swift_temp_url_key').with_value(params[:swift_temp_url_key]).with_secret(true)
        is_expected.to contain_ironic_config('glance/swift_temp_url_duration').with_value(params[:swift_temp_url_duration])
        is_expected.to contain_ironic_config('glance/endpoint_override').with_value(params[:endpoint_override])
      end
    end

    context 'when overriding parameters swift_account_project_name' do
      before :each do
        params.merge!(
          :swift_account_project_name => 'abc',
        )
      end
      it 'should set swift_account with new value' do
        is_expected.to contain_ironic_config('glance/swift_account').with_value('abc').with_transform_to('project_uuid')
      end
    end

    context 'when system_scope is set' do
      before do
        params.merge!(
          :system_scope => 'all'
        )
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_ironic_config('glance/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('glance/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('glance/system_scope').with_value('all')
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

      it_behaves_like 'ironic glance configuration'
    end
  end

end
