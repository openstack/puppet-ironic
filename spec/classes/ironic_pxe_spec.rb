require 'spec_helper'

describe 'ironic::pxe' do

  let :params do
    {}
  end

  shared_examples_for 'ironic pxe' do
    it 'should contain directory /tftpboot with selinux type tftpdir_t' do
      is_expected.to contain_file('/tftpboot').with(
        'owner'   => 'ironic',
        'group'   => 'ironic',
        'require' => 'Anchor[ironic::config::begin]',
        'ensure'  => 'directory',
        'seltype' => 'tftpdir_t',
      )
    end

    it 'should contain directory /tftpboot/pxelinux.cfg with selinux type tftpdir_t' do
      is_expected.to contain_file('/tftpboot/pxelinux.cfg').with(
        'owner'   => 'ironic',
        'group'   => 'ironic',
        'require' => 'Anchor[ironic::install::end]',
        'ensure'  => 'directory',
        'seltype' => 'tftpdir_t',
      )
    end

    it 'should contain directory /httpboot with selinux type httpd_sys_content_t' do
      is_expected.to contain_file('/httpboot').with(
        'owner'   => 'ironic',
        'group'   => 'ironic',
        'require' => 'Anchor[ironic::config::begin]',
        'ensure'  => 'directory',
        'seltype' => 'httpd_sys_content_t',
      )
    end

    it 'should contain syslinux package' do
      is_expected.to contain_package('syslinux').with(
        :ensure => 'present',
        :name   => platform_params[:syslinux_package],
        :tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
      )
    end

    it 'should contain ipxe package' do
      is_expected.to contain_package('ipxe').with(
        :ensure => 'present',
        :name   => platform_params[:ipxe_package],
        :tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
      )
    end

    it 'should contain iPXE chainload images' do
      is_expected.to contain_file('/tftpboot/undionly.kpxe').with(
        'owner'     => 'ironic',
        'group'     => 'ironic',
        'require'   => 'Anchor[ironic-inspector::install::end]',
        'seltype'   => 'tftpdir_t',
        'ensure'    => 'file',
        'show_diff' => false,
        'backup'    => false,
      )
    end
    it 'should contain iPXE UEFI chainload image' do
      is_expected.to contain_file("/tftpboot/#{platform_params[:uefi_ipxe_bootfile_name]}").with(
        'owner'     => 'ironic',
        'group'     => 'ironic',
        'require'   => 'Anchor[ironic-inspector::install::end]',
        'seltype'   => 'tftpdir_t',
        'ensure'    => 'file',
        'show_diff' => false,
        'backup'    => false,
      )
    end

    it 'should contain grub-efi package' do
      is_expected.to contain_package('grub-efi').with(
        :ensure => 'present',
        :name   => platform_params[:grub_efi_package],
        :tag    => ['openstack', 'ironic-support-package'],
      )
    end
    it 'should contain PXE UEFI shim image' do
      is_expected.to contain_file('/tftpboot/bootx64.efi').with(
        'owner'     => 'ironic',
        'group'     => 'ironic',
        'require'   => 'Anchor[ironic-inspector::install::end]',
        'seltype'   => 'tftpdir_t',
        'ensure'    => 'file',
        'show_diff' => false,
        'backup'    => false,
      )
    end
    it 'should contain shim package' do
      is_expected.to contain_package('shim').with(
        :ensure => 'present',
        :name   => platform_params[:shim_package],
        :tag    => ['openstack', 'ironic-support-package'],
      )
    end
    it 'should contain PXE UEFI grub image' do
      is_expected.to contain_file('/tftpboot/grubx64.efi').with(
        'owner'     => 'ironic',
        'group'     => 'ironic',
        'require'   => 'Anchor[ironic-inspector::install::end]',
        'seltype'   => 'tftpdir_t',
        'ensure'    => 'file',
        'show_diff' => false,
        'backup'    => false,
      )
    end

    it 'should configure http server' do
      is_expected.to contain_class('apache')
      is_expected.to contain_apache__vhost('ipxe_vhost').with(
        :priority => 10,
        :options  => ['Indexes','FollowSymLinks'],
        :docroot  => '/httpboot',
        :port     => 8088
      )
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :tftp_root      => '/var/lib/tftpboot',
          :http_root      => '/var/www/httpboot',
          :http_port      => 3816,
          :tftp_bind_host => '1.2.3.4',
        )
      end

      it 'should contain directory /var/www/httpboot with selinux type httpd_sys_content_t' do
        is_expected.to contain_file('/var/www/httpboot').with(
          'owner'   => 'ironic',
          'group'   => 'ironic',
          'require' => 'Anchor[ironic::config::begin]',
          'ensure'  => 'directory',
          'seltype' => 'httpd_sys_content_t',
        )
      end

      it 'should contain directory /var/lib/tftpboot with selinux type tftpdir_t' do
        is_expected.to contain_file('/var/lib/tftpboot').with(
          'owner'   => 'ironic',
          'group'   => 'ironic',
          'require' => 'Anchor[ironic::config::begin]',
          'ensure'  => 'directory',
          'seltype' => 'tftpdir_t',
        )
      end

      it 'should contain iPXE chainload images' do
        is_expected.to contain_file('/var/lib/tftpboot/undionly.kpxe').with(
          'owner'     => 'ironic',
          'group'     => 'ironic',
          'require'   => 'Anchor[ironic-inspector::install::end]',
          'seltype'   => 'tftpdir_t',
          'ensure'    => 'file',
          'show_diff' => false,
          'backup'    => false,
        )
      end
      it 'should contain iPXE UEFI chainload image' do
        is_expected.to contain_file("/var/lib/tftpboot/#{platform_params[:uefi_ipxe_bootfile_name]}").with(
          'owner'     => 'ironic',
          'group'     => 'ironic',
          'require'   => 'Anchor[ironic-inspector::install::end]',
          'seltype'   => 'tftpdir_t',
          'ensure'    => 'file',
          'show_diff' => false,
          'backup'    => false,
        )
      end

      it 'should contain PXE UEFI shim image' do
        is_expected.to contain_file('/var/lib/tftpboot/bootx64.efi').with(
          'owner'     => 'ironic',
          'group'     => 'ironic',
          'require'   => 'Anchor[ironic-inspector::install::end]',
          'seltype'   => 'tftpdir_t',
          'ensure'    => 'file',
          'show_diff' => false,
          'backup'    => false,
        )
      end
      it 'should contain PXE UEFI grub image' do
        is_expected.to contain_file('/var/lib/tftpboot/grubx64.efi').with(
          'owner'     => 'ironic',
          'group'     => 'ironic',
          'require'   => 'Anchor[ironic-inspector::install::end]',
          'seltype'   => 'tftpdir_t',
          'ensure'    => 'file',
          'show_diff' => false,
          'backup'    => false,
        )
      end

      it 'should configure http server' do
        is_expected.to contain_class('apache')
        is_expected.to contain_apache__vhost('ipxe_vhost').with(
          :priority => 10,
          :options  => ['Indexes','FollowSymLinks'],
          :docroot  => '/var/www/httpboot',
          :port     => 3816,
        )
      end
    end

    context 'when excluding syslinux' do
      before :each do
        params.merge!(
          :syslinux_path => false,
        )
      end
      it 'should not contain syslinux package' do
        is_expected.not_to contain_package('syslinux')
      end
      it 'should not contain tftpboot syslinux file' do
        is_expected.not_to contain_file('/var/lib/ironic/tftpboot/chain.c32')
      end
    end

    context 'when http server disabled' do
      before :each do
        params.merge!(
          :manage_http_server => false,
        )
      end
      it 'should not configure http server' do
        is_expected.not_to contain_class('apache')
        is_expected.not_to contain_apache__vhost('ipxe_vhost')
      end
    end
  end

  shared_examples_for 'ironic pxe with xinetd' do
    before :each do
      params.merge!(
        :tftp_use_xinetd => true,
      )
    end

    it 'should install tftp-server package' do
      is_expected.to contain_package('tftp-server').with(
        'ensure' => 'present',
        'name'   => platform_params[:tftp_package]
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
       'per_source'  => '11',
       'wait'        => 'yes',
       'subscribe'   => 'Anchor[ironic::install::end]',
      )
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :tftp_root      => '/var/lib/tftpboot',
          :http_root      => '/var/www/httpboot',
          :http_port      => 3816,
          :tftp_bind_host => '1.2.3.4',
        )
      end

      it 'should setup tftp xinetd service' do
        is_expected.to contain_class('xinetd')
        is_expected.to contain_xinetd__service('tftp').with(
         'port'        => '69',
         'protocol'    => 'udp',
         'server_args' => '--map-file /var/lib/tftpboot/map-file /var/lib/tftpboot',
         'server'      => '/usr/sbin/in.tftpd',
         'socket_type' => 'dgram',
         'cps'         => '100 2',
         'per_source'  => '11',
         'wait'        => 'yes',
         'subscribe'   => 'Anchor[ironic::install::end]',
        )
      end
      it 'should setup tftp xinetd service' do
        is_expected.to contain_xinetd__service('tftp').with(
         'bind' => '1.2.3.4',
        )
      end
    end
  end

  shared_examples_for 'ironic pxe without xinetd' do
    before :each do
      params.merge!(
        :tftp_use_xinetd => false,
      )
    end

    it 'should configure dnsmasq-tftp-server' do
      is_expected.to contain_file('/etc/ironic/dnsmasq-tftp-server.conf').with(
        'ensure' => 'present',
        'mode'   => '0644',
        'owner'  => 'root',
        'group'  => 'root',
      )
      is_expected.to contain_package('dnsmasq-tftp-server').with(
        'ensure' => 'present',
        'name'   => platform_params[:dnsmasq_tftp_package],
        'tag'    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
      )
      is_expected.to contain_service('dnsmasq-tftp-server').with(
        'ensure'    => 'running',
        'name'      => platform_params[:dnsmasq_tftp_service],
        'enable'    => true,
        'hasstatus' => true,
      )
    end

    it 'should not enable xinetd' do
      is_expected.to_not contain_package('tftp-server')
      is_expected.to_not contain_class('xinetd')
      is_expected.to_not contain_xinetd__service('tftp')
      is_expected.to contain_file('/tftpboot/map-file').with_ensure('absent')
    end
  end

  shared_examples_for 'ironic pxe with pxelinux package' do
    it 'should contain pxelinux package' do
      is_expected.to contain_package('pxelinux').with(
        :ensure => 'present',
        :name   => platform_params[:pxelinux_package],
        :tag    => ['openstack', 'ironic-ipxe', 'ironic-support-package'],
      )
    end

    context 'when excluding pxelinux' do
      before :each do
        params.merge!(
          :pxelinux_path => false,
        )
      end
      it 'should not contain pxelinux package' do
        is_expected.not_to contain_package('pxelinux')
      end
      it 'should not contain pxelinux.0 file' do
        is_expected.not_to contain_file('/var/lib/ironic/tftpboot/pxelinux.0')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          if facts[:operatingsystem] == 'Ubuntu' and facts[:operatingsystemmajrelease] <= '20.04'
            {
              :grub_efi_package        => 'grub-efi-amd64-signed',
              :ipxe_package            => 'ipxe',
              :shim_package            => 'shim-signed',
              :pxelinux_package        => 'pxelinux',
              :syslinux_package        => 'syslinux-common',
              :tftp_package            => 'tftpd-hpa',
              :uefi_ipxe_bootfile_name => 'ipxe.efi'
            }
          else
            {
              :grub_efi_package        => 'grub-efi-amd64-signed',
              :ipxe_package            => 'ipxe',
              :shim_package            => 'shim-signed',
              :pxelinux_package        => 'pxelinux',
              :syslinux_package        => 'syslinux-common',
              :tftp_package            => 'tftpd-hpa',
              :uefi_ipxe_bootfile_name => 'snponly.efi'
            }
          end
        when 'RedHat'
          {
            :dnsmasq_tftp_package    => 'openstack-ironic-dnsmasq-tftp-server',
            :dnsmasq_tftp_service    => 'openstack-ironic-dnsmasq-tftp-server',
            :grub_efi_package        => 'grub2-efi-x64',
            :ipxe_package            => 'ipxe-bootimgs',
            :shim_package            => 'shim',
            :syslinux_package        => 'syslinux-tftpboot',
            :tftp_package            => 'tftp-server',
            :uefi_ipxe_bootfile_name => 'snponly.efi'
          }
        end
      end

      it_behaves_like 'ironic pxe'

      if facts[:osfamily] == 'RedHat'
        it_behaves_like 'ironic pxe without xinetd'
      end

      unless facts[:osfamily] == 'RedHat' and facts[:operatingsystemmajrelease].to_i >= 9
        it_behaves_like 'ironic pxe with xinetd'
      end

      if facts[:osfamily] == 'Debian'
        it_behaves_like 'ironic pxe with pxelinux package' 
      end
    end
  end

end
