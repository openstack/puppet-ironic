require 'spec_helper'

describe 'ironic::db::sync' do

  shared_examples_for 'ironic-dbsync' do

    it 'runs ironic-manage db_sync' do
      is_expected.to contain_exec('ironic-dbsync').with(
        :command     => 'ironic-dbsync --config-file /etc/ironic/ironic.conf ',
        :path        => '/usr/bin',
        :user        => 'root',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end

    describe "overriding extra_params" do
        let :params do
            {
                :extra_params => '--config-file /etc/ironic/ironic_01.conf',
            }
        end
        it { is_expected.to contain_exec('ironic-dbsync').with(
            :command     => 'ironic-dbsync --config-file /etc/ironic/ironic.conf --config-file /etc/ironic/ironic_01.conf',
            :path        => '/usr/bin',
            :user        => 'root',
            :refreshonly => true,
            :logoutput   => 'on_failure'
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

      it_configures 'ironic-dbsync'
    end
  end

end
