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
# Unit tests for ironic::drivers::ipmi class
#

require 'spec_helper'

describe 'ironic::drivers::ipmi' do

  shared_examples_for 'ironic ipmi driver' do
    context 'with defaults' do
      it 'configures defaults' do
        is_expected.to contain_ironic_config('ipmi/command_retry_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('ipmi/min_command_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('ipmi/use_ipmitool_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('ipmi/kill_on_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('ipmi/disable_boot_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('ipmi/additional_retryable_ipmi_errors').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('ipmi/debug').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ironic_config('ipmi/cipher_suite_versions').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding parameters' do
      let :params do
        {
          :command_retry_timeout            => 50,
          :min_command_interval             => 5,
          :use_ipmitool_retries             => false,
          :kill_on_timeout                  => true,
          :disable_boot_timeout             => true,
          :additional_retryable_ipmi_errors => ['error1', 'error2'],
          :debug                            => true,
          :cipher_suite_versions            => ['1', '2'],
        }
      end

      it 'configures the given values' do
        is_expected.to contain_ironic_config('ipmi/command_retry_timeout').with_value(50)
        is_expected.to contain_ironic_config('ipmi/min_command_interval').with_value(5)
        is_expected.to contain_ironic_config('ipmi/use_ipmitool_retries').with_value(false)
        is_expected.to contain_ironic_config('ipmi/kill_on_timeout').with_value(true)
        is_expected.to contain_ironic_config('ipmi/disable_boot_timeout').with_value(true)
        is_expected.to contain_ironic_config('ipmi/additional_retryable_ipmi_errors').with_value(['error1', 'error2'])
        is_expected.to contain_ironic_config('ipmi/debug').with_value(true)
        is_expected.to contain_ironic_config('ipmi/cipher_suite_versions').with_value('1,2')
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

      it_behaves_like 'ironic ipmi driver'

    end
  end

end
