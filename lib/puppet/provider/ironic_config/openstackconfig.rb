require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/ironic')

Puppet::Type.type(:ironic_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/ironic/ironic.conf'
  end

  def to_project_uuid(name)
    warning('to_project_uuid is deprecated and will be removed in a future release.')
    properties = [name, '--column', 'id']
    openstack = Puppet::Provider::Ironic::OpenstackRequest.new
    res = openstack.openstack_request('project', 'show', properties)
    return "AUTH_#{res[:id]}"
  end

  def from_project_uuid(uuid)
    warning('from_project_uuid is deprecated and will be removed in a future release.')
    uuid = uuid.sub('AUTH_','')
    properties = [uuid, '--column', 'name']
    openstack = Puppet::Provider::Ironic::OpenstackRequest.new
    res = openstack.openstack_request('project', 'show', properties)
    return "AUTH_#{res[:name]}"
  end
end
