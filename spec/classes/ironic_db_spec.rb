require 'spec_helper'

describe 'ironic::db' do

  shared_examples 'ironic::db' do

    context 'with default parameters' do

      it { is_expected.to contain_oslo__db('ironic_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'sqlite:////var/lib/ironic/ovs.sqlite',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
      )}

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://ironic:ironic@localhost/ironic',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_pool_size  => '21',
          :database_max_retries    => '11',
          :database_max_overflow   => '21',
          :database_retry_interval => '11',
          :database_db_max_retries => '-1',
        }
      end

      it { is_expected.to contain_oslo__db('ironic_config').with(
        :db_max_retries => '-1',
        :connection     => 'mysql+pymysql://ironic:ironic@localhost/ironic',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :max_pool_size  => '21',
        :max_retries    => '11',
        :retry_interval => '11',
        :max_overflow   => '21',
      )}

    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection => 'mysql://ironic:ironic@localhost/ironic' }
      end

      it { is_expected.to contain_oslo__db('ironic_config').with(
        :connection => 'mysql://ironic:ironic@localhost/ironic',
      )}
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection => 'postgresql://ironic:ironic@localhost/ironic', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'redis://ironic:ironic@localhost/ironic', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'foo+pymysql://ironic:ironic@localhost/ironic', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  shared_examples_for 'ironic::db on Debian platforms' do

    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://ironic:ironic@localhost/ironic' }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-pymysql').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => ['openstack'],
        )
      end
    end

    context 'with sqlite backend' do
      let :params do
        { :database_connection => 'sqlite:///var/lib/nova/nova.sqlite', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-pysqlite2').with(
          :ensure => 'present',
          :name   => 'python-pysqlite2',
          :tag    => ['openstack'],
        )
      end
    end

  end

  shared_examples_for 'ironic::db on RedHat platforms' do

    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://ironic:ironic@localhost/ironic' }
      end

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

      case facts[:osfamily]
      when 'Debian'
        it_behaves_like 'ironic::db on Debian platforms'
      when 'RedHat'
        it_behaves_like 'ironic::db on RedHat platforms'
      end

      it_behaves_like 'ironic::db'
    end
  end

end
