require 'spec_helper'

describe 'ironic::db::postgresql' do

  shared_examples_for 'ironic::db::postgresql' do
    let :req_params do
      { :password => 'pw' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('ironic::deps') }

      it { is_expected.to contain_postgresql__server__db('ironic').with(
        :user     => 'ironic',
        :password => 'md554bdb85e136b50c40104fd9f73e1294d'
      )}
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

      # TODO(tkajinam): Remove this once puppet-postgresql supports CentOS 9
      unless facts[:osfamily] == 'RedHat' and facts[:operatingsystemmajrelease].to_i >= 9
        it_behaves_like 'ironic::db::postgresql'
      end
    end
  end

end
