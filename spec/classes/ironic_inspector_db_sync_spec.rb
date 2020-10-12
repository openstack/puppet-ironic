require 'spec_helper'

describe 'ironic::inspector::db::sync' do

  shared_examples_for 'inspector-dbsync' do

    it { is_expected.to contain_class('ironic::deps') }

    it 'runs ironic-inspectror-db_sync' do
      is_expected.to contain_exec('ironic-inspector-dbsync').with(
        :command     => 'ironic-inspector-dbsync --config-file /etc/ironic-inspector/inspector.conf upgrade',
        :path        => '/usr/bin',
        :user        => 'ironic-inspector',
        :refreshonly => 'true',
        :logoutput   => 'on_failure',
        :tag         => 'openstack-db',
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end
      it_behaves_like 'inspector-dbsync'
    end
  end

end
