require 'spec_helper'

describe 'ironic::logging' do

  let :params do
    {
    }
  end

  let :log_params do
    {
      :logging_context_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s',
      :logging_default_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s',
      :logging_debug_format_suffix => '%(funcName)s %(pathname)s:%(lineno)d',
      :logging_exception_prefix => '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s',
      :log_config_append => '/etc/ironic/logging.conf',
      :publish_errors => true,
      :default_log_levels => {
          'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
          'sqlalchemy' => 'WARN', 'suds' => 'INFO', 'iso8601' => 'WARN',
          'requests.packages.urllib3.connectionpool' => 'WARN' },
     :fatal_deprecations => true,
     :instance_format => '[instance: %(uuid)s] ',
     :instance_uuid_format => '[instance: %(uuid)s] ',
     :log_date_format => '%Y-%m-%d %H:%M:%S',
     :use_syslog => true,
     :use_stderr => false,
     :log_facility => 'LOG_FOO',
     :log_dir => '/var/log',
     :debug => true,
    }
  end

  let :empty_log_dir_param do
    {
      :log_dir => '',
    }
  end


  shared_examples_for 'ironic-logging' do

    context 'with basic logging options and default settings' do
      it_configures  'basic default logging settings'
    end

    context 'with basic logging options and non-default settings' do
      before { params.merge!( log_params ) }
      it_configures 'basic non-default logging settings'
    end

    context 'with extended logging options' do
      before { params.merge!( log_params ) }
      it_configures 'logging params set'
    end

    context 'without extended logging options' do
      it_configures 'logging params unset'
    end

    context 'with empty log_dir' do
      before { params.merge!( empty_log_dir_param ) }
      it_configures 'empty log dir'
    end

  end

  shared_examples 'basic default logging settings' do
    it 'configures ironic logging settings with default values' do
      is_expected.to contain_oslo__log('ironic_config').with(
        :use_syslog          => '<SERVICE DEFAULT>',
        :use_stderr          => '<SERVICE DEFAULT>',
        :syslog_log_facility => '<SERVICE DEFAULT>',
        :log_dir             => '/var/log/ironic',
        :debug               => '<SERVICE DEFAULT>',
      )
    end
  end

  shared_examples 'basic non-default logging settings' do
    it 'configures ironic logging settings with non-default values' do
      is_expected.to contain_oslo__log('ironic_config').with(
        :use_syslog          => true,
        :use_stderr          => false,
        :syslog_log_facility => 'LOG_FOO',
        :log_dir             => '/var/log',
        :debug               => true,
      )
    end
  end

  shared_examples_for 'logging params set' do
    it 'enables logging params' do
      is_expected.to contain_oslo__log('ironic_config').with(
        :logging_context_format_string =>
          '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s',
        :logging_default_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s',
        :logging_debug_format_suffix   => '%(funcName)s %(pathname)s:%(lineno)d',
        :logging_exception_prefix      => '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s',
        :log_config_append             => '/etc/ironic/logging.conf',
        :publish_errors                => true,
        :default_log_levels            => {
          'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
          'sqlalchemy' => 'WARN', 'suds' => 'INFO', 'iso8601' => 'WARN',
          'requests.packages.urllib3.connectionpool' => 'WARN' },
       :fatal_deprecations             => true,
       :instance_format                => '[instance: %(uuid)s] ',
       :instance_uuid_format           => '[instance: %(uuid)s] ',
       :log_date_format                => '%Y-%m-%d %H:%M:%S',
      )
    end
  end

  shared_examples_for 'logging params unset' do
   [ :logging_context_format_string, :logging_default_format_string,
     :logging_debug_format_suffix, :logging_exception_prefix,
     :log_config_append, :publish_errors,
     :default_log_levels, :fatal_deprecations,
     :instance_format, :instance_uuid_format,
     :log_date_format, ].each { |param|
        it { is_expected.to contain_oslo__log('ironic_config').with("#{param}" => '<SERVICE DEFAULT>') }
      }
  end

  shared_examples 'empty log dir' do
    it 'configures ironic logging with empty log dir' do
      is_expected.to contain_oslo__log('ironic_config').with(
        :log_dir => '',
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'ironic-logging'

    end
  end

end
