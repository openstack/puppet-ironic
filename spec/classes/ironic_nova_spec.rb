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
# Unit tests for ironic::nova
#

require 'spec_helper'

describe 'ironic::nova' do

  shared_examples_for 'ironic nova configuration' do
    context 'with defaults' do
      let :params do
        { :password => 'secret' }
      end

      it 'configures ironic.conf' do
        is_expected.to contain_ironic_config('nova/auth_type').with_value('password')
        is_expected.to contain_ironic_config('nova/auth_url').with_value('http://127.0.0.1:5000')
        is_expected.to contain_ironic_config('nova/project_name').with_value('services')
        is_expected.to contain_ironic_config('nova/username').with_value('ironic')
        is_expected.to contain_ironic_config('nova/password').with_value('secret').with_secret(true)
        is_expected.to contain_ironic_config('nova/user_domain_name').with_value('Default')
        is_expected.to contain_ironic_config('nova/project_domain_name').with_value('Default')
        is_expected.to contain_ironic_config('nova/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('nova/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('nova/endpoint_override').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('nova/send_power_notifications').with_value(true)
      end
    end

    context 'when overriding parameters' do
      let :params do
        {
          :password                 => 'secret',
          :auth_type                => 'noauth',
          :auth_url                 => 'http://example.com',
          :project_name             => 'project1',
          :username                 => 'admin',
          :user_domain_name         => 'NonDefault',
          :project_domain_name      => 'NonDefault',
          :region_name              => 'regionTwo',
          :endpoint_override        => 'http://example2.com',
          :send_power_notifications => true,
        }
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('nova/auth_type').with_value(params[:auth_type])
        is_expected.to contain_ironic_config('nova/auth_url').with_value(params[:auth_url])
        is_expected.to contain_ironic_config('nova/project_name').with_value(params[:project_name])
        is_expected.to contain_ironic_config('nova/username').with_value(params[:username])
        is_expected.to contain_ironic_config('nova/user_domain_name').with_value(params[:user_domain_name])
        is_expected.to contain_ironic_config('nova/project_domain_name').with_value(params[:project_domain_name])
        is_expected.to contain_ironic_config('nova/region_name').with_value(params[:region_name])
        is_expected.to contain_ironic_config('nova/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('nova/endpoint_override').with_value(params[:endpoint_override])
        is_expected.to contain_ironic_config('nova/send_power_notifications').with_value(params[:send_power_notifications])
      end
    end

    context 'when system_scope is set' do
      let :params do
        {
          :password     => 'secret',
          :system_scope => 'all',
        }
      end

      it 'configures system-scoped credential' do
        is_expected.to contain_ironic_config('nova/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('nova/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('nova/system_scope').with_value('all')
      end
    end

    context 'when send_power_notifications is false' do
      let :params do
        { :send_power_notifications => false }
      end

      it 'configures only send_power_notifications' do
        is_expected.to contain_ironic_config('nova/auth_type').with_ensure('absent')
        is_expected.to contain_ironic_config('nova/auth_url').with_ensure('absent')
        is_expected.to contain_ironic_config('nova/project_name').with_ensure('absent')
        is_expected.to contain_ironic_config('nova/username').with_ensure('absent')
        is_expected.to contain_ironic_config('nova/user_domain_name').with_ensure('absent')
        is_expected.to contain_ironic_config('nova/project_domain_name').with_ensure('absent')
        is_expected.to contain_ironic_config('nova/region_name').with_ensure('absent')
        is_expected.to contain_ironic_config('nova/system_scope').with_ensure('absent')
        is_expected.to contain_ironic_config('nova/endpoint_override').with_ensure('absent')
        is_expected.to contain_ironic_config('nova/send_power_notifications').with_value(false)
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

      it_behaves_like 'ironic nova configuration'
    end
  end

end
