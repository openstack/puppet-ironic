require 'spec_helper'

describe 'ironic::db::sync' do

  shared_examples_for 'ironic-dbsync' do

    it { is_expected.to contain_class('ironic::deps') }

    it 'runs ironic-manage db_sync' do
      is_expected.to contain_exec('ironic-dbsync').with(
        :command     => 'ironic-dbsync --config-file /etc/ironic/ironic.conf ',
        :path        => '/usr/bin',
        :user        => 'ironic',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[ironic::install::end]',
                         'Anchor[ironic::config::end]',
                         'Anchor[ironic::dbsync::begin]'],
        :notify      => 'Anchor[ironic::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

    describe "overriding params" do
        let :params do
            {
                :extra_params    => '--config-file /etc/ironic/ironic_01.conf',
                :db_sync_timeout => 750,
            }
        end
        it { is_expected.to contain_exec('ironic-dbsync').with(
            :command     => 'ironic-dbsync --config-file /etc/ironic/ironic.conf --config-file /etc/ironic/ironic_01.conf',
            :path        => '/usr/bin',
            :user        => 'ironic',
            :refreshonly => true,
            :try_sleep   => 5,
            :tries       => 10,
            :timeout     => 750,
            :logoutput   => 'on_failure',
            :subscribe   => ['Anchor[ironic::install::end]',
                             'Anchor[ironic::config::end]',
                             'Anchor[ironic::dbsync::begin]'],
            :notify      => 'Anchor[ironic::dbsync::end]',
            :tag         => 'openstack-db',
        )
        }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_behaves_like 'ironic-dbsync'
    end
  end

end
