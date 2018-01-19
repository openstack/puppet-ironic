require 'spec_helper'

describe 'ironic::db::online_data_migrations' do

  shared_examples_for 'ironic-db-online-data-migrations' do

    it 'runs ironic-db-sync' do
      is_expected.to contain_exec('ironic-db-online-data-migrations').with(
        :command     => 'ironic-dbsync --config-file /etc/ironic/ironic.conf  online_data_migrations ',
        :path        => '/usr/bin',
        :user        => 'ironic',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[ironic::install::end]',
                         'Anchor[ironic::config::end]',
                         'Anchor[ironic::dbsync::end]',
                         'Anchor[ironic::db_online_data_migrations::begin]'],
        :notify      => 'Anchor[ironic::db_online_data_migrations::end]',
      )
    end

    describe "overriding extra_params" do
      let :params do
        {
          :extra_params     => '--config-file /etc/ironic/ironic_01.conf',
          :migration_params => '--max-count 100',
        }
      end

      it {
        is_expected.to contain_exec('ironic-db-online-data-migrations').with(
          :command     => 'ironic-dbsync --config-file /etc/ironic/ironic.conf --config-file /etc/ironic/ironic_01.conf online_data_migrations --max-count 100',
          :path        => '/usr/bin',
          :user        => 'ironic',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[ironic::install::end]',
                           'Anchor[ironic::config::end]',
                           'Anchor[ironic::dbsync::end]',
                           'Anchor[ironic::db_online_data_migrations::begin]'],
          :notify      => 'Anchor[ironic::db_online_data_migrations::end]',
        )
      }
    end

  end


  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'ironic-db-online-data-migrations'
    end
  end

end
