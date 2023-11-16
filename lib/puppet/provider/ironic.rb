require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'

class Puppet::Provider::Ironic < Puppet::Provider::Openstack
  extend Puppet::Provider::Openstack::Auth

  def self.system_request(service, actuon, properties=nil, options={})
    self.request(service, action, properties, options, 'system')
  end
end
