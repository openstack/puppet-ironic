#
# Copyright (C) 2015 Red Hat Inc.
#
# Author: Dan Prince <dprince@eredhat.com>
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
#
# Unit tests for ironic::keystone::auth_inspector
#

require 'spec_helper'

describe 'ironic::keystone::auth_inspector' do
  shared_examples_for 'ironic::keystone::auth_inspector' do
    context 'with default class parameters' do
      let :params do
        { :password => 'ironic-inspector_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('ironic-inspector').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :configure_service   => true,
        :service_name        => 'ironic-inspector',
        :service_type        => 'baremetal-introspection',
        :auth_name           => 'ironic-inspector',
        :service_description => 'Bare Metal Introspection Service',
        :region              => 'RegionOne',
        :password            => 'ironic-inspector_password',
        :email               => 'ironic-inspector@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:5050',
        :internal_url        => 'http://127.0.0.1:5050',
        :admin_url           => 'http://127.0.0.1:5050',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'ironic-inspector_password',
          :auth_name           => 'alt_ironic-inspector',
          :email               => 'alt_ironic-inspector@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :configure_service   => false,
          :service_description => 'Alternative Bare Metal Introspection Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_baremetal-introspection',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('ironic-inspector').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_baremetal-introspection',
        :auth_name           => 'alt_ironic-inspector',
        :service_description => 'Alternative Bare Metal Introspection Service',
        :region              => 'RegionTwo',
        :password            => 'ironic-inspector_password',
        :email               => 'alt_ironic-inspector@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'ironic::keystone::auth_inspector'
    end
  end
end
