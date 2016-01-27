require 'spec_helper'

describe 'ironic::db' do

  shared_examples 'ironic::db' do

    context 'with default parameters' do

      it { is_expected.to contain_ironic_config('database/connection').with_value('sqlite:////var/lib/ironic/ovs.sqlite').with_secret(true) }
      it { is_expected.to contain_ironic_config('database/idle_timeout').with_value('3600') }
      it { is_expected.to contain_ironic_config('database/min_pool_size').with_value('1') }
      it { is_expected.to contain_ironic_config('database/max_pool_size').with_value('10') }
      it { is_expected.to contain_ironic_config('database/max_overflow').with_value('20') }
      it { is_expected.to contain_ironic_config('database/max_retries').with_value('10') }
      it { is_expected.to contain_ironic_config('database/retry_interval').with_value('10') }

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://ironic:ironic@localhost/ironic',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_pool_size  => '21',
          :database_max_retries    => '11',
          :database_max_overflow   => '21',
          :database_retry_interval => '11', }
      end

      it { is_expected.to contain_ironic_config('database/connection').with_value('mysql+pymysql://ironic:ironic@localhost/ironic').with_secret(true)}
      it { is_expected.to contain_ironic_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_ironic_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_ironic_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_ironic_config('database/max_pool_size').with_value('21') }
      it { is_expected.to contain_ironic_config('database/max_overflow').with_value('21') }
      it { is_expected.to contain_ironic_config('database/retry_interval').with_value('11') }

    end


    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection => 'mysql://ironic:ironic@localhost/ironic' }
      end

      it { is_expected.to contain_ironic_config('database/connection').with_value('mysql://ironic:ironic@localhost/ironic').with_secret(true) }
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


  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => 'jessie',
      }
    end

    it_configures 'ironic::db'

    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql://ironic:ironic@localhost/ironic' }
      end

      it { is_expected.to contain_package('ironic-backend-package').with({ :ensure => 'present', :name => 'python-pymysql' }) }
    end
  end

  context 'on Redhat platforms' do
    let :facts do
      { :osfamily => 'RedHat',
        :operatingsystemrelease => '7.1',
      }
    end

    it_configures 'ironic::db'

    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql://ironic:ironic@localhost/ironic' }
      end

      it { is_expected.not_to contain_package('ironic-backend-package') }
    end
  end

end
