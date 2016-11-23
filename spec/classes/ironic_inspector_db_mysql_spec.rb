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
# Unit tests for ironic::inspector::db::mysql
#

require 'spec_helper'

describe 'ironic::inspector::db::mysql' do

  shared_examples_for 'ironic::inspector::db::mysql' do
    let :req_params do
      { :password => 'passw0rd' }
    end

    let :pre_condition do
      'include mysql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_openstacklib__db__mysql('ironic-inspector').with(
        :user          => 'ironic-inspector',
        :password_hash => '*74B1C21ACE0C2D6B0678A5E503D2A60E8F9651A3',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
      )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'ironic::inspector::db::mysql'
    end
  end

end
