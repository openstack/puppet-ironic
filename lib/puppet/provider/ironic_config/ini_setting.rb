require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/ironic')

Puppet::Type.type(:ironic_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do


  def self.file_path
    '/etc/ironic/ironic.conf'
  end

  def to_net_uuid(name)
     properties = [name, '--column', 'id']
     openstack = Puppet::Provider::Ironic::OpenstackRequest.new
     res = openstack.openstack_request('network', 'show', properties)
     return res[:id]
  end

  def from_net_uuid(uuid)
    properties = [uuid, '--column', 'name']
    openstack = Puppet::Provider::Ironic::OpenstackRequest.new
    res = openstack.openstack_request('network', 'show', properties)
    return res[:name]
  end

  def to_project_uuid(name)
     properties = [name, '--column', 'id']
     openstack = Puppet::Provider::Ironic::OpenstackRequest.new
     res = openstack.openstack_request('project', 'show', properties)
     return "AUTH_#{res[:id]}"
  end

  def from_project_uuid(uuid)
    uuid = uuid.sub('AUTH_','')
    properties = [uuid, '--column', 'name']
    openstack = Puppet::Provider::Ironic::OpenstackRequest.new
    res = openstack.openstack_request('project', 'show', properties)
    return "AUTH_#{res[:name]}"
  end

end
