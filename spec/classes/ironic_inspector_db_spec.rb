require 'spec_helper'

describe 'ironic::inspector::db' do

  shared_examples 'ironic::inspector::db' do

    context 'with default parameters' do

      it { is_expected.to contain_ironic_inspector_config('database/connection').with_value('sqlite:////var/lib/ironic-inspector/inspector.sqlite').with_secret(true) }
      it { is_expected.to contain_ironic_inspector_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_inspector_config('database/min_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_inspector_config('database/max_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_inspector_config('database/max_overflow').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_inspector_config('database/pool_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_inspector_config('database/max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_inspector_config('database/db_max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_ironic_inspector_config('database/retry_interval').with_value('<SERVICE DEFAULT>') }

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://ironic:ironic@localhost/ironic',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_pool_size  => '21',
          :database_max_retries    => '11',
          :database_db_max_retries => '11',
          :database_max_overflow   => '21',
          :database_pool_timeout   => '21',
          :database_retry_interval => '11', }
      end

      it { is_expected.to contain_ironic_inspector_config('database/connection').with_value('mysql+pymysql://ironic:ironic@localhost/ironic').with_secret(true) }
      it { is_expected.to contain_ironic_inspector_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_ironic_inspector_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_ironic_inspector_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_ironic_inspector_config('database/db_max_retries').with_value('11') }
      it { is_expected.to contain_ironic_inspector_config('database/max_pool_size').with_value('21') }
      it { is_expected.to contain_ironic_inspector_config('database/max_overflow').with_value('21') }
      it { is_expected.to contain_ironic_inspector_config('database/pool_timeout').with_value('21') }
      it { is_expected.to contain_ironic_inspector_config('database/retry_interval').with_value('11') }

    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection => 'mysql://ironic:ironic@localhost/ironic' }
      end

      it { is_expected.to contain_ironic_inspector_config('database/connection').with_value('mysql://ironic:ironic@localhost/ironic').with_secret(true) }
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://ironic:ironic@localhost/ironic', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'redis://ironic:ironic@localhost/ironic', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'foo+pymysql://ironic:ironic@localhost/ironic', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  shared_examples 'ironic::inspector::db on Debian platforms' do

    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql://ironic:ironic@localhost/ironic' }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-pymysql').with(
          :ensure => 'present',
          :name   => platform_params[:pymysql_package_name],
          :tag    => ['openstack'],
        )
      end
    end

    context 'with sqlite backend' do
      let :params do
        { :database_connection     => 'sqlite:///var/lib/ironic-inspector/inspector.sqlite', }
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

  shared_examples 'ironic::inspector::db on Redhat platforms' do

    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql://ironic:ironic@localhost/ironic' }
      end

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir         => '/var/lib/puppet/concat',
          :fqdn                   => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          if facts[:os_package_type] == 'debian' then
            pymysql_pkgname = 'python3-pymysql'
          else
            pymysql_pkgname = 'python-pymysql'
          end
          {
            :pymysql_package_name => pymysql_pkgname,
          }
        when 'RedHat'
          {
            :pymysql_package_name => 'python-pymysql',
          }
        end
      end

      case facts[:osfamily]
      when 'Debian'
        it_behaves_like 'ironic::inspector::db on Debian platforms'
      when 'RedHat'
        it_behaves_like 'ironic::inspector::db on Redhat platforms'
      end

      it_behaves_like 'ironic::inspector::db'
    end
  end

end
