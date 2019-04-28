require 'spec_helper'

describe 'ironic::inspector::db' do

  shared_examples 'ironic::inspector::db' do

    context 'with default parameters' do
      it { should contain_oslo__db('ironic_inspector_config').with(
        :connection              => 'sqlite:////var/lib/ironic-inspector/inspector.sqlite',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :min_pool_size           => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :db_max_retries          => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
      )}

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection              => 'mysql+pymysql://ironic:ironic@localhost/ironic',
          :database_connection_recycle_time => '3601',
          :database_min_pool_size           => '2',
          :database_max_pool_size           => '21',
          :database_max_retries             => '11',
          :database_db_max_retries          => '11',
          :database_max_overflow            => '21',
          :database_pool_timeout            => '21',
          :database_retry_interval          => '11', }
      end

      it { should contain_oslo__db('ironic_inspector_config').with(
        :connection              => 'mysql+pymysql://ironic:ironic@localhost/ironic',
        :connection_recycle_time => '3601',
        :min_pool_size           => '2',
        :max_pool_size           => '21',
        :max_retries             => '11',
        :db_max_retries          => '11',
        :pool_timeout            => '21',
        :retry_interval          => '11',
        :max_overflow            => '21',
      )}

    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      it_behaves_like 'ironic::inspector::db'
    end
  end

end
