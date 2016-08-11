require 'spec_helper'

describe 'ironic::pxe' do

  let :default_params do
    { :package_ensure => 'present',
      :tftp_root      => '/tftpboot',
      :http_root      => '/httpboot',
      :ipxe_timeout   => 0,
      :http_port      => 8088, }
  end

  let :params do
    {}
  end

  shared_examples_for 'ironic pxe' do
    let :p do
      default_params.merge(params)
    end

    it 'should contain directory /tftpboot with selinux type tftpdir_t' do
      is_expected.to contain_file('/tftpboot').with(
        'owner'   => 'ironic',
        'group'   => 'ironic',
        'require' => 'Package[ironic-common]',
        'ensure'  => 'directory',
        'seltype' => 'tftpdir_t',
      )
    end

    it 'should contain directory /httpboot with selinux type httpd_sys_content_t' do
      is_expected.to contain_file('/httpboot').with(
        'owner'   => 'ironic',
        'group'   => 'ironic',
        'require' => 'Package[ironic-common]',
        'ensure'  => 'directory',
        'seltype' => 'httpd_sys_content_t',
      )
    end

    it 'should install tftp-server package' do
      is_expected.to contain_package('tftp-server').with(
        'ensure' => 'present',
      )
    end

    it 'should setup tftp xinetd service' do
      is_expected.to contain_class('xinetd')
      is_expected.to contain_xinetd__service('tftp').with(
       'port'        => '69',
       'protocol'    => 'udp',
       'server_args' => '--map-file /tftpboot/map-file /tftpboot',
       'server'      => '/usr/sbin/in.tftpd',
       'socket_type' => 'dgram',
       'cps'         => '100 2',
       'flags'       => 'IPv4',
       'per_source'  => '11',
       'wait'        => 'yes',
       'require'     => 'Package[tftp-server]',
      )
      is_expected.to contain_service('tftpd-hpa').with(
        'ensure' => 'stopped',
        'enable' => false,
      )
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :tftp_root => '/var/lib/tftpboot',
          :http_root => '/var/www/httpboot',
          :http_port => 3816,
        )
      end

      it 'should contain directory /var/www/httpboot with selinux type httpd_sys_content_t' do
        is_expected.to contain_file('/var/www/httpboot').with(
          'owner'   => 'ironic',
          'group'   => 'ironic',
          'require' => 'Package[ironic-common]',
          'ensure'  => 'directory',
          'seltype' => 'httpd_sys_content_t',
        )
      end

      it 'should contain directory /var/lib/tftpboot with selinux type tftpdir_t' do
        is_expected.to contain_file('/var/lib/tftpboot').with(
          'owner'   => 'ironic',
          'group'   => 'ironic',
          'require' => 'Package[ironic-common]',
          'ensure'  => 'directory',
          'seltype' => 'tftpdir_t',
        )
      end

      it 'should contain iPXE chainload images' do
        is_expected.to contain_file('/var/lib/tftpboot/undionly.kpxe').with(
          'owner'   => 'ironic',
          'group'   => 'ironic',
          'require' => 'Package[ipxe]',
          'seltype' => 'tftpdir_t',
          'ensure'  => 'present',
          'backup'  => false,
        )
      end
      it 'should contain iPXE UEFI chainload image' do
        is_expected.to contain_file('/var/lib/tftpboot/ipxe.efi').with(
          'owner'   => 'ironic',
          'group'   => 'ironic',
          'require' => 'Package[ipxe]',
          'seltype' => 'tftpdir_t',
          'ensure'  => 'present',
          'backup'  => false,
        )
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7.0'
      })
    end

    it_configures 'ironic pxe'
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '7.2.1511'
      })
    end

    it_configures 'ironic pxe'
  end

end
