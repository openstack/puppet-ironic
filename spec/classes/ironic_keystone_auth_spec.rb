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
# Unit tests for ironic::keystone::auth
#

require 'spec_helper'

describe 'ironic::keystone::auth' do
  shared_examples_for 'ironic::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'ironic_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('ironic').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :configure_service   => true,
        :service_name        => 'ironic',
        :service_type        => 'baremetal',
        :service_description => 'Ironic Bare Metal Provisioning Service',
        :region              => 'RegionOne',
        :auth_name           => 'ironic',
        :password            => 'ironic_password',
        :email               => 'ironic@localhost',
        :tenant              => 'services',
        :roles               => ['admin', 'service'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:6385',
        :internal_url        => 'http://127.0.0.1:6385',
        :admin_url           => 'http://127.0.0.1:6385',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'ironic_password',
          :auth_name           => 'alt_ironic',
          :email               => 'alt_ironic@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :configure_service   => false,
          :service_description => 'Alternative Ironic Bare Metal Provisioning Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_baremetal',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('ironic').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_baremetal',
        :service_description => 'Alternative Ironic Bare Metal Provisioning Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_ironic',
        :password            => 'ironic_password',
        :email               => 'alt_ironic@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin'],
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

      it_behaves_like 'ironic::keystone::auth'
    end
  end
end
