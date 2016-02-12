require 'spec_helper'

describe 'ironic::inspector::db::postgresql' do

  shared_examples_for 'ironic::inspector::db::postgresql' do
    let :req_params do
      { :password => 'pw' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('ironic-inspector').with(
        :user     => 'ironic-inspector',
        :password => 'md5f4da35e834f32b2deceef0dcd269e195'
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

      it_configures 'ironic::inspector::db::postgresql'
    end
  end

end
