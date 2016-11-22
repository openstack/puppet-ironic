# Copyright 2016 Red Hat, Inc.
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Unit tests for ironic::drivers::ipmi class
#

require 'spec_helper'

describe 'ironic::drivers::ssh' do

  shared_examples_for 'ironic driver ssh' do

    context 'with default parameters' do
      it { is_expected.to contain_ironic_config('ssh/libvirt_uri').with_value('<SERVICE DEFAULT>') }
    end

    context 'when overriding parameters' do
      let :params do
        { :libvirt_uri => 'qemu:///session' }
      end

      it { is_expected.to contain_ironic_config('ssh/libvirt_uri').with_value('qemu:///session') }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it_behaves_like 'ironic driver ssh'
    end
  end

end
