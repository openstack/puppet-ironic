require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'
require 'puppet/provider/openstack/credentials'

class Puppet::Provider::Ironic < Puppet::Provider

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
