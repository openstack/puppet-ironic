require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/ironic')

Puppet::Type.type(:ironic_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/ironic/ironic.conf'
  end

  def to_project_uuid(name)
    properties = [name, '--column', 'id']
    ironic_provider = Puppet::Provider::Ironic
    res = ironic_provider.system_request('project', 'show', properties)
    return "AUTH_#{res[:id]}"
  end

  def from_project_uuid(uuid)
    uuid = uuid.sub('AUTH_','')
    properties = [uuid, '--column', 'name']
    ironic_provider = Puppet::Provider::Ironic
    res = ironic_provider.system_request('project', 'show', properties)
    return res[:name]
  end
end
