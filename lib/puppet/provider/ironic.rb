require 'csv'
require 'puppet/util/inifile'
require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'
require 'puppet/provider/openstack/credentials'

class Puppet::Provider::Ironic < Puppet::Provider

  def self.conf_filename
    '/etc/ironic/ironic.conf'
  end

  def self.withenv(hash, &block)
    saved = ENV.to_hash
    hash.each do |name, val|
      ENV[name.to_s] = val
    end

    yield
  ensure
    ENV.clear
    saved.each do |name, val|
      ENV[name] = val
    end
  end

  def self.ironic_credentials
    @ironic_credentials ||= get_ironic_credentials
  end

  def self.get_ironic_credentials
    auth_keys = ['auth_uri', 'project_name', 'username', 'password']
    conf = ironic_conf
    if conf and conf['keystone_authtoken'] and
        auth_keys.all?{|k| !conf['keystone_authtoken'][k].nil?}
      creds = Hash[ auth_keys.map \
                   { |k| [k, conf['keystone_authtoken'][k].strip] } ]
      if !conf['keystone_authtoken']['project_domain_name'].nil?
        creds['project_domain_name'] = conf['keystone_authtoken']['project_domain_name'].strip
      else
        creds['project_domain_name'] = 'Default'
      end
      if !conf['keystone_authtoken']['user_domain_name'].nil?
        creds['user_domain_name'] = conf['keystone_authtoken']['user_domain_name'].strip
      else
        creds['user_domain_name'] = 'Default'
      end
      return creds
    else
      raise(Puppet::Error, "File: #{conf_filename} does not contain all \
required sections.  Ironic types will not work if ironic is not \
correctly configured.")
    end
  end

  def ironic_credentials
    self.class.ironic_credentials
  end

  def self.ironic_conf
    return @ironic_conf if @ironic_conf
    @ironic_conf = Puppet::Util::IniConfig::File.new
    @ironic_conf.read(conf_filename)
    @ironic_conf
  end

  def self.auth_ironic(*args)
    q = ironic_credentials
    authenv = {
      :OS_AUTH_URL            => q['auth_uri'],
      :OS_USERNAME            => q['username'],
      :OS_PROJECT_NAME        => q['project_name'],
      :OS_PASSWORD            => q['password'],
      :OS_PROJECT_DOMAIN_NAME => q['project_domain_name'],
      :OS_USER_DOMAIN_NAME    => q['user_domain_name'],
    }
    begin
      withenv authenv do
        ironic(args)
      end
    rescue Exception => e
      if (e.message =~ /\[Errno 111\] Connection refused/) or
          (e.message =~ /\(HTTP 400\)/)
        sleep 10
        withenv authenv do
          ironic(args)
        end
      else
       raise(e)
      end
    end
  end

  def auth_ironic(*args)
    self.class.auth_ironic(args)
  end

  def self.reset
    @ironic_conf        = nil
    @ironic_credentials = nil
  end

  def self.list_ironic_resources(type)
    ids = []
    list = auth_ironic("#{type}-list", '--format=csv',
                        '--column=id', '--quote=none')
    (list.split("\n")[1..-1] || []).compact.collect do |line|
      ids << line.strip
    end
    return ids
  end

  def self.get_ironic_resource_attrs(type, id)
    attrs = {}
    net = auth_ironic("#{type}-show", '--format=shell', id)
    last_key = nil
    (net.split("\n") || []).compact.collect do |line|
      if line.include? '='
        k, v = line.split('=', 2)
        attrs[k] = v.gsub(/\A"|"\Z/, '')
        last_key = k
      else
        # Handle the case of a list of values
        v = line.gsub(/\A"|"\Z/, '')
        attrs[last_key] = [attrs[last_key], v]
      end
    end
    return attrs
  end

  def self.get_tenant_id(catalog, name)
    instance_type = 'keystone_tenant'
    instance = catalog.resource("#{instance_type.capitalize!}[#{name}]")
    if ! instance
      instance = Puppet::Type.type(instance_type).instances.find do |i|
        i.provider.name == name
      end
    end
    if instance
      return instance.provider.id
    else
      fail("Unable to find #{instance_type} for name #{name}")
    end
  end

  def self.parse_creation_output(data)
    hash = {}
    data.split("\n").compact.each do |line|
      if line.include? '='
        hash[line.split('=').first] = line.split('=', 2)[1].gsub(/\A"|"\Z/, '')
      end
    end
    hash
  end
end

class Puppet::Provider::Ironic::OpenstackRequest
  include Puppet::Provider::Openstack::Auth

  def openstack_request(service, action, properties=nil, options={})
    credentials = Puppet::Provider::Openstack::CredentialsV3.new
    openstack = Puppet::Provider::Openstack

    set_credentials(credentials, get_os_vars_from_env)
      unless credentials.set?
        credentials.unset
        set_credentials(credentials, get_os_vars_from_rcfile(rc_filename))
      end
    unless credentials.set?
        raise(Puppet::Error::OpenstackAuthInputError, 'Insufficient credentials to authenticate')
    end

    openstack.request(service, action, properties, credentials, options)
  end
end
