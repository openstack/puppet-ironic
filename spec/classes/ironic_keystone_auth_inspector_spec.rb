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
# Unit tests for ironic::keystone::auth_inspector
#

require 'spec_helper'

describe 'ironic::keystone::auth_inspector' do

  let :facts do
    @default_facts.merge({ :osfamily => 'Debian' })
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'ironic_inspector_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_user('ironic-inspector').with(
      :ensure   => 'present',
      :password => 'ironic_inspector_password',
    ) }

    it { is_expected.to contain_keystone_user_role('ironic-inspector@foobar').with(
      :ensure  => 'present',
      :roles   => ['admin']
    )}

    it { is_expected.to contain_keystone_service('ironic-inspector::baremetal-introspection').with(
      :ensure      => 'present',
      :type        => 'baremetal-introspection',
      :description => 'Bare Metal Introspection Service'
    ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/ironic-inspector::baremetal-introspection').with(
      :ensure       => 'present',
      :public_url   => "http://127.0.0.1:5050",
      :admin_url    => "http://127.0.0.1:5050",
      :internal_url => "http://127.0.0.1:5050"
    ) }
  end

  describe 'when configuring ironic-inspector' do
    let :pre_condition do
      "class { 'ironic::inspector': auth_password => 'test' }"
    end

    let :params do
      { :password => 'ironic_password',
        :tenant   => 'foobar' }
    end

  end

  describe 'with endpoint parameters' do
    let :params do
      { :password     => 'ironic_password',
        :public_url   => 'https://10.0.0.10:5050',
        :admin_url    => 'https://10.0.0.11:5050',
        :internal_url => 'https://10.0.0.11:5050' }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/ironic-inspector::baremetal-introspection').with(
      :ensure       => 'present',
      :public_url   => 'https://10.0.0.10:5050',
      :admin_url    => 'https://10.0.0.11:5050',
      :internal_url => 'https://10.0.0.11:5050'
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'inspecty' }
    end

    it { is_expected.to contain_keystone_user('inspecty') }
    it { is_expected.to contain_keystone_user_role('inspecty@services') }
    it { is_expected.to contain_keystone_service('inspecty::baremetal-introspection') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/inspecty::baremetal-introspection') }
  end

  describe 'when overriding service name' do
    let :params do
      {
        :service_name => 'inspector_service',
        :password     => 'ironic_password',
      }
    end

    it { is_expected.to contain_keystone_user('ironic-inspector') }
    it { is_expected.to contain_keystone_user_role('ironic-inspector@services') }
    it { is_expected.to contain_keystone_service('inspector_service::baremetal-introspection') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/inspector_service::baremetal-introspection') }
  end

  describe 'when disabling user configuration' do

    let :params do
      {
        :password       => 'ironic_password',
        :configure_user => false
      }
    end

    it { is_expected.not_to contain_keystone_user('ironic-inspector') }

    it { is_expected.to contain_keystone_user_role('ironic-inspector@services') }

    it { is_expected.to contain_keystone_service('ironic-inspector::baremetal-introspection').with(
      :ensure      => 'present',
      :type        => 'baremetal-introspection',
      :description => 'Bare Metal Introspection Service'
    ) }

  end

  describe 'when disabling user and user role configuration' do

    let :params do
      {
        :password            => 'ironic_password',
        :configure_user      => false,
        :configure_user_role => false
      }
    end

    it { is_expected.not_to contain_keystone_user('ironic-inspector') }

    it { is_expected.not_to contain_keystone_user_role('ironic-inspector@services') }

    it { is_expected.to contain_keystone_service('ironic-inspector::baremetal-introspection').with(
      :ensure      => 'present',
      :type        => 'baremetal-introspection',
      :description => 'Bare Metal Introspection Service'
    ) }

  end

end
