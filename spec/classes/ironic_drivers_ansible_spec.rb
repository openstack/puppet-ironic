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

describe 'ironic::drivers::ansible' do

  let :params do
    {}
  end

  shared_examples_for 'ironic ansible deploy interface' do
    let :p do
      params
    end

    it 'configures ironic.conf' do
      is_expected.to contain_ironic_config('ansible/ansible_extra_args').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('ansible/playbooks_path').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('ansible/config_file_path').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ironic_config('ansible/image_store_insecure').with_value('<SERVICE DEFAULT>')
    end

    it 'installs ansible package' do
      is_expected.to contain_package('ansible').with(
        :ensure => 'present',
        :name   => 'ansible',
        :tag    => ['openstack', 'ironic-package'],
      )
      is_expected.to contain_package('systemd-python').with(
        :ensure => 'present',
        :name   => platform_params[:systemd_python_package],
        :tag    => ['openstack', 'ironic-package'],
      )
    end

    context 'when overriding parameters' do
      before do
        params.merge!(:ansible_extra_args => '--foo',
                      :playbooks_path => '/home/stack/playbooks',
                      :config_file_path => '/home/stack/ansible.cfg',
                      :image_store_insecure => true)
      end
      it 'should replace default parameter with new value' do
        is_expected.to contain_ironic_config('ansible/ansible_extra_args').with_value(p[:ansible_extra_args])
        is_expected.to contain_ironic_config('ansible/playbooks_path').with_value(p[:playbooks_path])
        is_expected.to contain_ironic_config('ansible/config_file_path').with_value(p[:config_file_path])
        is_expected.to contain_ironic_config('ansible/image_store_insecure').with_value(p[:image_store_insecure])
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

      let :platform_params do
        case facts[:osfamily]
        when 'Debian'
          { :systemd_python_package => 'python-systemd' }
        when 'RedHat'
          { :systemd_python_package => 'systemd-python' }
        end
      end

      it_behaves_like 'ironic ansible deploy interface'
    end
  end

end
