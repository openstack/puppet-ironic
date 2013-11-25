require 'spec_helper'

describe 'ironic::db::mysql::host_access' do

  let :pre_condition do
    'include mysql'
  end

  let :title do
    '127.0.0.1'
  end

  let :params do
    { :user     => 'ironic',
      :password => 'passw0rd',
      :database => 'ironic' }
  end

  let :facts do
    { :osfamily => 'Debian' }
  end

  it { should contain_database_user('ironic@127.0.0.1') }
  it { should contain_database_grant('ironic@127.0.0.1/ironic') }
end
