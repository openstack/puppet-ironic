require 'spec_helper'

describe 'ironic::db::inspector_sync' do

  shared_examples_for 'inspector-dbsync' do

    it 'runs ironic-inspectror-db_sync' do
      is_expected.to contain_exec('ironic-inspector-dbsync').with(
        :command     => 'ironic-inspector-dbsync --config-file /etc/ironic-inspector/inspector.conf upgrade',
        :path        => '/usr/bin',
        :user        => 'ironic-inspector',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end

  end

  context 'on a RedHat osfamily' do
    let :facts do
      {
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'inspector-dbsync'
  end

  context 'on a Debian osfamily' do
    let :facts do
      {
        :operatingsystemrelease => '7.8',
        :operatingsystem        => 'Debian',
        :osfamily               => 'Debian',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'inspector-dbsync'
  end

end
