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
# Unit tests for ironic::neutron
#

require 'spec_helper'

describe 'ironic::neutron' do

  let :params do
    { :password => 'secret' }
  end

  shared_examples_for 'ironic neutron configuration' do
    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('neutron/auth_type').with_value('password')
      is_expected.to contain_ironic_config('neutron/auth_url').with_value('http://127.0.0.1:5000')
      is_expected.to contain_ironic_config('neutron/project_name').with_value('services')
      is_expected.to contain_ironic_config('neutron/username').with_value('ironic')
      is_expected.to contain_ironic_config('neutron/password').with_value('secret').with_secret(true)
      is_expected.to contain_ironic_config('neutron/user_domain_name').with_value('Default')
      is_expected.to contain_ironic_config('neutron/project_domain_name').with_value('Default')
      is_expected.to contain_ironic_config('neutron/system_scope').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/region_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/endpoint_override').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('neutron/dhcpv6_stateful_address_count').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :auth_type                     => 'noauth',
          :auth_url                      => 'http://example.com',
          :project_name                  => 'project1',
          :username                      => 'admin',
          :user_domain_name              => 'NonDefault',
          :project_domain_name           => 'NonDefault',
          :region_name                   => 'regionTwo',
          :endpoint_override             => 'http://example2.com',
          :dhcpv6_stateful_address_count => 8,
        )
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('neutron/auth_type').with_value(params[:auth_type])
        is_expected.to contain_ironic_config('neutron/auth_url').with_value(params[:auth_url])
        is_expected.to contain_ironic_config('neutron/project_name').with_value(params[:project_name])
        is_expected.to contain_ironic_config('neutron/username').with_value(params[:username])
        is_expected.to contain_ironic_config('neutron/user_domain_name').with_value(params[:user_domain_name])
        is_expected.to contain_ironic_config('neutron/project_domain_name').with_value(params[:project_domain_name])
        is_expected.to contain_ironic_config('neutron/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('neutron/region_name').with_value(params[:region_name])
        is_expected.to contain_ironic_config('neutron/endpoint_override').with_value(params[:endpoint_override])
        is_expected.to contain_ironic_config('neutron/dhcpv6_stateful_address_count').with_value(params[:dhcpv6_stateful_address_count])
      end
    end

    context 'when system_scope is set' do
      before do
        params.merge!(
          :system_scope => 'all'
        )
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_ironic_config('neutron/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('neutron/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('neutron/system_scope').with_value('all')
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

      it_behaves_like 'ironic neutron configuration'
    end
  end

end
