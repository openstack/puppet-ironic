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
# Unit tests for ironic::drivers::agent class
#

require 'spec_helper'

describe 'ironic::drivers::agent' do

  let :params do
    {}
  end

  shared_examples_for 'ironic agent driver' do
    let :p do
      params
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('agent/stream_raw_images').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/image_download_source').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/post_deploy_get_power_state_retries').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/post_deploy_get_power_state_retry_interval').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/deploy_logs_collect').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/deploy_logs_storage_backend').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/deploy_logs_local_path').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/deploy_logs_swift_container').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/deploy_logs_swift_days_to_expire').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/command_timeout').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('agent/max_command_attempts').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before do
        params.merge!(:stream_raw_images => false,
                      :image_download_source => 'http',
                      :post_deploy_get_power_state_retries => 20,
                      :post_deploy_get_power_state_retry_interval => 10,
                      :deploy_logs_collect => 'always',
                      :deploy_logs_storage_backend => 'swift',
                      :deploy_logs_local_path => '/tmp',
                      :deploy_logs_swift_container => 'cont',
                      :deploy_logs_swift_days_to_expire => 5,
                      :command_timeout => 90,
                      :max_command_attempts => 5)
      end
      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('agent/stream_raw_images').with_value(p[:stream_raw_images])
        is_expected.to contain_ironic_config('agent/image_download_source').with_value(p[:image_download_source])
        is_expected.to contain_ironic_config('agent/post_deploy_get_power_state_retries').with_value(p[:post_deploy_get_power_state_retries])
        is_expected.to contain_ironic_config('agent/post_deploy_get_power_state_retry_interval').with_value(p[:post_deploy_get_power_state_retry_interval])
        is_expected.to contain_ironic_config('agent/deploy_logs_collect').with_value(p[:deploy_logs_collect])
        is_expected.to contain_ironic_config('agent/deploy_logs_storage_backend').with_value(p[:deploy_logs_storage_backend])
        is_expected.to contain_ironic_config('agent/deploy_logs_local_path').with_value(p[:deploy_logs_local_path])
        is_expected.to contain_ironic_config('agent/deploy_logs_swift_container').with_value(p[:deploy_logs_swift_container])
        is_expected.to contain_ironic_config('agent/deploy_logs_swift_days_to_expire').with_value(p[:deploy_logs_swift_days_to_expire])
        is_expected.to contain_ironic_config('agent/command_timeout').with_value(p[:command_timeout])
        is_expected.to contain_ironic_config('agent/max_command_attempts').with_value(p[:max_command_attempts])
      end
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end
      it_behaves_like 'ironic agent driver'
    end
  end

end
