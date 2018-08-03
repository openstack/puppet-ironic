require 'puppet'
require 'spec_helper'
require 'puppet/provider/ironic'
require 'tempfile'

describe Puppet::Provider::Ironic do

  def klass
    described_class
  end

  let :credential_hash do
    {
      'project_name'        => 'admin_tenant',
      'username'            => 'admin',
      'password'            => 'password',
      'auth_url'            => 'https://192.168.56.210:5000/',
      'project_domain_name' => 'admin_tenant_domain',
      'user_domain_name'    => 'admin_domain',
    }
  end

  let :credential_error do
    /Ironic types will not work/
  end

  after :each do
    klass.reset
  end

  describe 'when determining credentials' do

    it 'should fail if config is empty' do
      conf = {}
      klass.expects(:ironic_conf).returns(conf)
      expect do
        klass.ironic_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not have keystone_authtoken section.' do
      conf = {'foo' => 'bar'}
      klass.expects(:ironic_conf).returns(conf)
      expect do
        klass.ironic_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not contain all auth params' do
      conf = {'keystone_authtoken' => {'invalid_value' => 'foo'}}
      klass.expects(:ironic_conf).returns(conf)
      expect do
       klass.ironic_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

  end

  describe 'when invoking the ironic cli' do

    it 'should set auth credentials in the environment' do
      authenv = {
        :OS_AUTH_URL            => credential_hash['auth_url'],
        :OS_USERNAME            => credential_hash['username'],
        :OS_PROJECT_NAME        => credential_hash['project_name'],
        :OS_PASSWORD            => credential_hash['password'],
        :OS_PROJECT_DOMAIN_NAME => credential_hash['project_domain_name'],
        :OS_USER_DOMAIN_NAME    => credential_hash['user_domain_name'],
      }
      klass.expects(:get_ironic_credentials).with().returns(credential_hash)
      klass.expects(:withenv).with(authenv)
      klass.auth_ironic('test_retries')
    end

    ['[Errno 111] Connection refused',
     '(HTTP 400)'].reverse.each do |valid_message|
      it "should retry when ironic cli returns with error #{valid_message}" do
        klass.expects(:get_ironic_credentials).with().returns({})
        klass.expects(:sleep).with(10).returns(nil)
        klass.expects(:ironic).twice.with(['test_retries']).raises(
          Exception, valid_message).then.returns('')
        klass.auth_ironic('test_retries')
      end
    end

  end

  describe 'when listing ironic resources' do

    it 'should exclude the column header' do
      output = <<-EOT
        id
        net1
        net2
      EOT
      klass.expects(:auth_ironic).returns(output)
      result = klass.list_ironic_resources('foo')
      expect(result).to eql(['net1', 'net2'])
    end

  end

end
