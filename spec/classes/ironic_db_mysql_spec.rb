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
# Unit tests for ironic::db::mysql
#

require 'spec_helper'

describe 'ironic::db::mysql' do

  let :pre_condition do
    'include mysql::server'
  end

  let :params do
    { :password => 'passw0rd' }
  end
  let :facts do
      { :osfamily => 'Debian' }
  end


  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it { should contain_class('ironic::db::mysql') }
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it { should contain_class('ironic::db::mysql') }
  end

  describe "overriding allowed_hosts param to array" do
    let :params do
      {
        :password       => 'ironicpass',
        :allowed_hosts  => ['127.0.0.1','%']
      }
    end

    it {should_not contain_ironic__db__mysql__host_access("127.0.0.1").with(
      :user     => 'ironic',
      :password => 'ironicpass',
      :database => 'ironic'
    )}
    it {should contain_ironic__db__mysql__host_access("%").with(
      :user     => 'ironic',
      :password => 'ironicpass',
      :database => 'ironic'
    )}
  end

  describe "overriding allowed_hosts param to string" do
    let :params do
      {
        :password       => 'ironicpass2',
        :allowed_hosts  => '192.168.1.1'
      }
    end

    it {should contain_ironic__db__mysql__host_access("192.168.1.1").with(
      :user     => 'ironic',
      :password => 'ironicpass2',
      :database => 'ironic'
    )}
  end

  describe "overriding allowed_hosts param equals to host param " do
    let :params do
      {
        :password       => 'ironicpass2',
        :allowed_hosts  => '127.0.0.1'
      }
    end

    it {should_not contain_ironic__db__mysql__host_access("127.0.0.1").with(
      :user     => 'ironic',
      :password => 'ironicpass2',
      :database => 'ironic'
    )}
  end
end
