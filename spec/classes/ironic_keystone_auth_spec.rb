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

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'ironic_password',
        :tenant   => 'foobar' }
    end

    it { should contain_keystone_user('ironic').with(
      :ensure   => 'present',
      :password => 'ironic_password',
      :tenant   => 'foobar'
    ) }

    it { should contain_keystone_user_role('ironic@foobar').with(
      :ensure  => 'present',
      :roles   => 'admin'
    )}

    it { should contain_keystone_service('ironic').with(
      :ensure      => 'present',
      :type        => 'baremetal',
      :description => 'Ironic Networking Service'
    ) }

    it { should contain_keystone_endpoint('RegionOne/ironic').with(
      :ensure       => 'present',
      :public_url   => "http://127.0.0.1:6385/",
      :admin_url    => "http://127.0.0.1:6385/",
      :internal_url => "http://127.0.0.1:6385/"
    ) }
  end

  describe 'when configuring ironic-server' do
    let :pre_condition do
      "class { 'ironic::server': auth_password => 'test' }"
    end

    let :params do
      { :password => 'ironic_password',
        :tenant   => 'foobar' }
    end

    #FIXME it { should contain_keystone_endpoint('RegionOne/ironic').with_notify('Service[ironic-server]') }
  end

  describe 'when overriding public_protocol, public_port and public address' do
    let :params do
      { :password         => 'ironic_password',
        :public_protocol  => 'https',
        :public_port      => '80',
        :public_address   => '10.10.10.10',
        :port             => '81',
        :internal_address => '10.10.10.11',
        :admin_address    => '10.10.10.12' }
    end

    it { should contain_keystone_endpoint('RegionOne/ironic').with(
      :ensure       => 'present',
      :public_url   => "https://10.10.10.10:80/",
      :internal_url => "http://10.10.10.11:81/",
      :admin_url    => "http://10.10.10.12:81/"
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'ironicy' }
    end

    it { should contain_keystone_user('ironicy') }
    it { should contain_keystone_user_role('ironicy@services') }
    it { should contain_keystone_service('ironicy') }
    it { should contain_keystone_endpoint('RegionOne/ironicy') }
  end
end
