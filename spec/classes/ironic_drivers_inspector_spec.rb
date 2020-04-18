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
# Unit tests for ironic::drivers::inspector
#

require 'spec_helper'

describe 'ironic::drivers::inspector' do

  let :default_params do
    { :auth_type    => 'password',
      :project_name => 'services',
      :username     => 'ironic',
    }
  end

  let :params do
    {}
  end

  shared_examples_for 'ironic ironic-inspector access configuration' do
    let :p do
      default_params.merge(params)
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('inspector/auth_type').with_value(p[:auth_type])
      is_expected.to contain_ironic_config('inspector/auth_url').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('inspector/project_name').with_value(p[:project_name])
      is_expected.to contain_ironic_config('inspector/username').with_value(p[:username])
      is_expected.to contain_ironic_config('inspector/password').with_value('<SERVICE DEFAULT>').with_secret(true)
      is_expected.to contain_ironic_config('inspector/user_domain_name').with_value('Default')
      is_expected.to contain_ironic_config('inspector/project_domain_name').with_value('Default')
      is_expected.to contain_ironic_config('inspector/region_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('inspector/endpoint_override').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
            :auth_type                  => 'noauth',
            :auth_url                   => 'http://example.com',
            :project_name               => 'project1',
            :username                   => 'admin',
            :password                   => 'pa$$w0rd',
            :user_domain_name           => 'NonDefault',
            :project_domain_name        => 'NonDefault',
            :region_name                => 'regionTwo',
            :endpoint_override          => 'http://example2.com',
            :callback_endpoint_override => 'http://10.0.0.1/v1/continue',
            :power_off                  => false,
            :extra_kernel_params        => 'ipa-inspection-collectors=a,b,c',
        )
      end

      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('inspector/auth_type').with_value(p[:auth_type])
        is_expected.to contain_ironic_config('inspector/auth_url').with_value(p[:auth_url])
        is_expected.to contain_ironic_config('inspector/project_name').with_value(p[:project_name])
        is_expected.to contain_ironic_config('inspector/username').with_value(p[:username])
        is_expected.to contain_ironic_config('inspector/password').with_value(p[:password]).with_secret(true)
        is_expected.to contain_ironic_config('inspector/user_domain_name').with_value(p[:user_domain_name])
        is_expected.to contain_ironic_config('inspector/project_domain_name').with_value(p[:project_domain_name])
        is_expected.to contain_ironic_config('inspector/region_name').with_value(p[:region_name])
        is_expected.to contain_ironic_config('inspector/endpoint_override').with_value(p[:endpoint_override])
        is_expected.to contain_ironic_config('inspector/callback_endpoint_override').with_value(p[:callback_endpoint_override])
        is_expected.to contain_ironic_config('inspector/power_off').with_value(p[:power_off])
        is_expected.to contain_ironic_config('inspector/extra_kernel_params').with_value(p[:extra_kernel_params])
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

      it_behaves_like 'ironic ironic-inspector access configuration'
    end
  end

end
