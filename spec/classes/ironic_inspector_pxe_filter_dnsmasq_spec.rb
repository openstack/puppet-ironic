#
# Copyright (C) 2018 Red Hat, Inc
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
# Unit tests for ironic::inspector::pxe_filter::dnsmasq class
#

require 'spec_helper'

describe 'ironic::inspector::pxe_filter::dnsmasq' do
  let :pre_condition do
     "class { 'ironic::inspector::authtoken':
        password => 'password',
      }
      class { 'ironic::inspector':
        dnsmasq_dhcp_hostsdir => '/etc/ironic-inspector/dhcp-hostsdir',
      }"
  end

  shared_examples_for 'ironic::inspector::pxe_filter::dnsmasq' do
    it 'configure dnsmasq pxe filter default params' do
      is_expected.to contain_ironic_inspector_config('dnsmasq_pxe_filter/dhcp_hostsdir').with_value('/etc/ironic-inspector/dhcp-hostsdir')
      is_expected.to contain_ironic_inspector_config('dnsmasq_pxe_filter/dnsmasq_start_command').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('dnsmasq_pxe_filter/dnsmasq_stop_command').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_inspector_config('dnsmasq_pxe_filter/purge_dhcp_hostsdir').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
        /dhcp-hostsdir=\/etc\/ironic-inspector\/dhcp-hostsdir/
      )
    end

    context 'with specific parameters' do
      let :params do
        { :dnsmasq_start_command => 'dnsmasq --conf-file /etc/ironic-inspector/dnsmasq.conf',
          :dnsmasq_stop_command  => 'kill $(cat /var/run/dnsmasq.pid)',
          :purge_dhcp_hostsdir   => false,
        }
      end

      let :p do
        params
      end

      it 'configure dnsmasq pxe filter specific params' do
        is_expected.to contain_ironic_inspector_config('dnsmasq_pxe_filter/dhcp_hostsdir').with_value('/etc/ironic-inspector/dhcp-hostsdir')
        is_expected.to contain_ironic_inspector_config('dnsmasq_pxe_filter/dnsmasq_start_command').with_value(p[:dnsmasq_start_command])
        is_expected.to contain_ironic_inspector_config('dnsmasq_pxe_filter/dnsmasq_stop_command').with_value(p[:dnsmasq_stop_command])
        is_expected.to contain_ironic_inspector_config('dnsmasq_pxe_filter/purge_dhcp_hostsdir').with_value(p[:purge_dhcp_hostsdir])
        is_expected.to contain_file('/etc/ironic-inspector/dnsmasq.conf').with_content(
          /dhcp-hostsdir=\/etc\/ironic-inspector\/dhcp-hostsdir/
        )
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'ironic::inspector::pxe_filter::dnsmasq'
    end
  end

end
